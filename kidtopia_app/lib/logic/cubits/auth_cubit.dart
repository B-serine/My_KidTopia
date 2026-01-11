import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/user.dart' as user_model;
import '../../data/repositories/user_repository.dart';

// ==================== STATES ====================
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final user_model.User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// ==================== CUBIT ====================
class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;
  final SupabaseClient _supabase = Supabase.instance.client;
  user_model.User? _currentUser;

  AuthCubit(this._userRepository) : super(AuthInitial());

  user_model.User? get currentUser => _currentUser;

  Future<void> signUp({
    required String name,
    required String password,
    int? age,
    String? avatarUrl,
  }) async {
    emit(AuthLoading());
    try {
      final user = user_model.User(
        name: name,
        password: password,
        age: age,
        avatarUrl: avatarUrl,
        totalScore: 0,
        isPremium: false,
      );

      final result = await _userRepository.insertItem(user.toMap());
      if (result.state) {
        final createdUser = user.copyWith(id: result.data as int?);
        _currentUser = createdUser;
        emit(AuthAuthenticated(createdUser));
      } else {
        emit(AuthError(result.message));
      }
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }

  Future<void> signIn({required String name, required String password}) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.getByName(name);
      if (user == null) {
        emit(AuthError('User not found'));
        return;
      }
      if (user.password != password) {
        emit(AuthError('Incorrect password'));
        return;
      }
      _currentUser = user;
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError('Sign in failed: ${e.toString()}'));
    }
  }

  void signOut() {
    _currentUser = null;
    emit(AuthUnauthenticated());
  }

  Future<void> updateUserScore(int additionalPoints) async {
    if (_currentUser == null) return;

    try {
      final newScore = _currentUser!.totalScore + additionalPoints;
      final updatedUser = _currentUser!.copyWith(totalScore: newScore);
      
      // Update local SQLite
      final result = await _userRepository.updateItem(updatedUser.toMap());

      if (result.state) {
        // Update Supabase if user is logged in
        final supabaseUserId = _supabase.auth.currentUser?.id;
        if (supabaseUserId != null) {
          try {
            await _supabase.from('profiles').update({
              'total_score': newScore,
            }).eq('id', supabaseUserId);
          } catch (e) {
            print('Error updating score in Supabase: $e');
          }
        }
        
        _currentUser = updatedUser;
        emit(AuthAuthenticated(updatedUser));
      }
    } catch (e) {
      emit(AuthError('Failed to update score: ${e.toString()}'));
    }
  }

  Future<void> upgradeToPremium() async {
    if (_currentUser == null) return;

    emit(AuthLoading());
    
    try {
      final updatedUser = _currentUser!.copyWith(isPremium: true);
      
      // Update local SQLite database
      final result = await _userRepository.updateItem(updatedUser.toMap());
      
      if (result.state) {
        // Update Supabase if user is logged in
        final supabaseUserId = _supabase.auth.currentUser?.id;
        if (supabaseUserId != null) {
          try {
            await _supabase.from('profiles').update({
              'is_premium': true,
            }).eq('id', supabaseUserId);
            print('Successfully updated premium status in Supabase');
          } catch (e) {
            print('Error updating premium status in Supabase: $e');
            // Continue anyway since local update succeeded
          }
        }
        
        _currentUser = updatedUser;
        emit(AuthAuthenticated(updatedUser));
      } else {
        emit(AuthError('Failed to upgrade to premium'));
      }
    } catch (e) {
      emit(AuthError('Failed to upgrade: ${e.toString()}'));
    }
  }

  Future<void> refreshUser() async {
    if (_currentUser?.id == null) return;

    try {
      final user = await _userRepository.getById(_currentUser!.id!);
      if (user != null && user != _currentUser) {
        _currentUser = user;
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError('Failed to refresh: ${e.toString()}'));
    }
  }
}