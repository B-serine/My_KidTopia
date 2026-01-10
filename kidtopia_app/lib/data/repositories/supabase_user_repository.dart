import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgrest/postgrest.dart' show PostgrestException;
import 'package:kidtopia_app/data/models/result.dart';
import 'package:kidtopia_app/models/profile.dart';
import 'package:kidtopia_app/data/repositories/user_repository.dart';
import 'package:kidtopia_app/core/auth_utils.dart';

final _supabase = Supabase.instance.client;

class SupabaseUserRepository {
  final UserRepository _localRepo = UserRepository();

  String _emailForUsername(String username) =>
      '${username.trim()}@kidtopia.local';

  Future<ReturnResult> signUp({
    required String username,
    required String password,
    int? age,
    String? avatarUrl,
  }) async {
    try {
      if (password.length < 4)
        return ReturnResult(
          state: false,
          message: 'Password must be at least 4 characters',
        );
      final email = _emailForUsername(username);

      // Sign up with Supabase Auth (with retries for transient network failures)
      final res = await _retry(
        () => _supabase.auth.signUp(email: email, password: password),
      );

      final user = res.user;
      final session = res.session;
      if (user == null) {
        return ReturnResult(state: false, message: 'Failed to sign up');
      }

      // If the signUp did not create an immediate session (e.g. email
      // confirmation is required), the client is not yet authenticated and
      // attempting to insert/upsert rows protected by RLS that check
      // auth.uid() = id will fail. In that case, skip creating the profile
      // row here and instruct the user to verify their email. The profile
      // will be created automatically on first sign-in, or you can add a
      // DB trigger (see sql/supabase_auth_trigger_create_profile.sql).
      if (session == null) {
        final pendingProfile = Profile(
          id: user.id,
          name: username,
          username: username,
        );
        return ReturnResult(
          state: true,
          message:
              'Sign-up created. Please verify your email to complete account setup.',
          data: pendingProfile,
        );
      }

      // Ensure username is not taken (case-insensitive check against profiles.name/username)
      final existingName = await _retry(
        () => _supabase
            .from('profiles')
            .select('id')
            .ilike('name', username)
            .maybeSingle(),
      );
      final existingUsername = await _retry(
        () => _supabase
            .from('profiles')
            .select('id')
            .ilike('username', username)
            .maybeSingle(),
      );
      if (existingName != null || existingUsername != null) {
        return ReturnResult(state: false, message: 'Username already exists');
      }

      // Hash password with salt
      final pw = AuthUtils.hashPassword(password);
      final salt = pw['salt']!;
      final hash = pw['hash']!;

      // Create (upsert) profile tied to the Auth UID (profiles.id expected to be auth user id)
      final profileMap = {
        'id': user.id,
        'name': username,
        'username': username,
        'age': age,
        'avatar_url': avatarUrl,
        'total_score': 0,
        'is_premium': false,
        'password_hash': hash,
        'password_salt': salt,
        'created_at': DateTime.now().toIso8601String(),
      };

      final upsertRes = await _retry(
        () => _supabase
            .from('profiles')
            .upsert(profileMap)
            .select()
            .maybeSingle(),
      );
      if (upsertRes == null) {
        return ReturnResult(
          state: false,
          message: 'Failed to create profile in Supabase',
        );
      }

      final profile = Profile.fromJson(upsertRes as Map<String, dynamic>);

      // Mirror to local DB (store salt:hash in password column)
      final localPasswordStored = '$salt:$hash';
      final localInsert = await _localRepo.insertItem({
        'name': username,
        'password': localPasswordStored,
        'age': age,
        'avatar_url': avatarUrl,
        'total_score': 0,
        'is_premium': 0,
        'created_at': DateTime.now().toIso8601String(),
      });
      // ignore local username collision (might already exist if offline-created)
      if (!localInsert.state &&
          localInsert.message?.toLowerCase().contains('username') == true) {
        // already exists locally; this is acceptable
      }

      return ReturnResult(
        state: true,
        message: 'Signed up successfully',
        data: profile,
      );
    } on PostgrestException catch (e) {
      return ReturnResult(
        state: false,
        message: 'Database error: ${e.message}. Check RLS policies.',
      );
    } catch (e) {
      if (e is SocketException) {
        return ReturnResult(
          state: false,
          message: 'Network error: ${e.message}',
        );
      }
      return ReturnResult(
        state: false,
        message: 'Sign up error: ${e.toString()}',
      );
    }
  }

  Future<ReturnResult> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final email = _emailForUsername(username);

      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final session = res.session;
      final user = session?.user ?? res.user;

      if (user == null) {
        // Fallback: try local DB auth
        final localUser = await _localRepo.getByName(username);
        if (localUser == null) {
          return ReturnResult(state: false, message: 'Invalid credentials');
        }

        final stored = localUser.password; // stored as 'salt:hash'
        if (stored == null || !AuthUtils.verifyPassword(password, stored)) {
          return ReturnResult(state: false, message: 'Invalid credentials');
        }

        return ReturnResult(
          state: true,
          message: 'Signed in locally',
          data: localUser,
        );
      }

      // Fetch profile from Supabase
      // Fetch profile from Supabase by auth UID
      var profileRes = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // If no profile exists in Supabase, create one automatically using the email prefix as username
      if (profileRes == null) {
        final baseUsername = (user.email ?? 'user')
            .split('@')
            .first
            .replaceAll(RegExp(r"[^a-zA-Z0-9_]"), '');
        final uniqueUsername = await _generateUniqueUsername(baseUsername);
        final created = await _supabase
            .from('profiles')
            .upsert({
              'id': user.id,
              'name': uniqueUsername,
              'username': uniqueUsername,
              'age': null,
              'avatar_url': null,
              'total_score': 0,
              'is_premium': false,
              'created_at': DateTime.now().toIso8601String(),
            })
            .select()
            .maybeSingle();
        if (created == null) {
          return ReturnResult(
            state: false,
            message: 'Failed to create profile for user',
          );
        }
        profileRes = created;
      }

      final profileData = profileRes as Map<String, dynamic>;
      final profile = Profile.fromJson(profileData);

      // Mirror to local DB for offline fallback
      final existingLocal = await _localRepo.getByName(
        profile.username ?? profile.name ?? '',
      );
      if (existingLocal == null) {
        final pw = AuthUtils.hashPassword(password);
        final localPasswordStored = '${pw['salt']}:${pw['hash']}';
        await _localRepo.insertItem({
          'name': profile.username ?? profile.name ?? '',
          'password': localPasswordStored,
          'age': profile.age,
          'avatar_url': profile.avatarUrl,
          'total_score': profile.totalScore,
          'is_premium': profile.isPremium ? 1 : 0,
          'created_at': profile.createdAt?.toIso8601String(),
        });
      } else {
        // update local total score and avatar
        final updated = existingLocal.copyWith(
          age: profile.age,
          avatarUrl: profile.avatarUrl,
          totalScore: profile.totalScore,
          isPremium: profile.isPremium,
        );
        await _localRepo.updateItem(updated.toMap());
      }

      return ReturnResult(state: true, message: 'Signed in', data: profile);
    } on PostgrestException catch (e) {
      return ReturnResult(
        state: false,
        message:
            'Database error: ${e.message}. Check RLS policies and permissions.',
      );
    } catch (e) {
      if (e is SocketException) {
        return ReturnResult(
          state: false,
          message: 'Network error: ${e.message}',
        );
      }
      return ReturnResult(
        state: false,
        message: 'Sign in error: ${e.toString()}',
      );
    }
  }

  Future<ReturnResult> signOut() async {
    try {
      await _retry(() => _supabase.auth.signOut());
      return ReturnResult(state: true, message: 'Signed out');
    } catch (e) {
      if (e is SocketException)
        return ReturnResult(
          state: false,
          message: 'Network error: ${e.message}',
        );
      return ReturnResult(
        state: false,
        message: 'Sign out error: ${e.toString()}',
      );
    }
  }

  Future<Profile?> getProfileById(String id) async {
    final res = await _supabase
        .from('profiles')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return Profile.fromJson(res as Map<String, dynamic>);
  }

  Future<Profile?> getProfileByUsername(String username) async {
    final res = await _supabase
        .from('profiles')
        .select()
        .eq('username', username)
        .maybeSingle();
    if (res == null) return null;
    return Profile.fromJson(res as Map<String, dynamic>);
  }

  Future<ReturnResult> updateProfile(Profile profile) async {
    try {
      final res = await _supabase
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id)
          .select()
          .maybeSingle();
      if (res == null) {
        return ReturnResult(state: false, message: 'Failed to update profile');
      }
      final updated = Profile.fromJson(res as Map<String, dynamic>);

      // Optionally update local DB: simple update by username
      final localUser = await _localRepo.getByName(updated.username ?? '');
      if (localUser != null) {
        final updatedLocal = localUser.copyWith(
          age: updated.age,
          avatarUrl: updated.avatarUrl,
          totalScore: updated.totalScore,
          isPremium: updated.isPremium,
        );
        await _localRepo.updateItem(updatedLocal.toMap());
      }

      return ReturnResult(
        state: true,
        message: 'Profile updated',
        data: updated,
      );
    } catch (e) {
      return ReturnResult(
        state: false,
        message: 'Update error: ${e.toString()}',
      );
    }
  }

  Future<List<Profile>> listProfiles() async {
    final res = await _supabase.from('profiles').select();
    if (res == null) return [];
    final data = res as List<dynamic>;
    return data
        .map((e) => Profile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Generate a unique username by appending numbers if needed
  Future<String> _generateUniqueUsername(String base) async {
    String candidate = base;
    int suffix = 1;
    while (true) {
      final existing = await _supabase
          .from('profiles')
          .select('id')
          .ilike('username', candidate)
          .maybeSingle();
      if (existing == null) return candidate;
      candidate = '$base${suffix++}';
    }
  }

  // Helpers: hashing and verification moved to AuthUtils
  // Use AuthUtils.hashPassword(...) and AuthUtils.verifyPassword(...) where needed

  // Retry helper for transient network errors
  Future<T> _retry<T>(Future<T> Function() fn, {int retries = 3}) async {
    int attempt = 0;
    while (true) {
      try {
        return await fn();
      } on SocketException catch (e) {
        attempt += 1;
        if (attempt >= retries) rethrow;
        await Future.delayed(Duration(seconds: attempt));
      }
    }
  }
}
