import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';

// ==================== STATES ====================
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
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
  User? _currentUser;

  AuthCubit(this._userRepository) : super(AuthInitial());

  User? get currentUser => _currentUser;

  Future<void> signUp({
    required String name,
    required String password,
    int? age,
    String? avatarUrl,
  }) async {
    emit(AuthLoading());
    try {
      final user = User(
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
      final result = await _userRepository.updateItem(updatedUser.toMap());

      if (result.state) {
        _currentUser = updatedUser;
        emit(AuthAuthenticated(updatedUser));
      }
    } catch (e) {
      emit(AuthError('Failed to update score: ${e.toString()}'));
    }
  }

  Future<void> upgradeToPremium() async {
    if (_currentUser == null) return;

    try {
      final updatedUser = _currentUser!.copyWith(isPremium: true);
      final result = await _userRepository.updateItem(updatedUser.toMap());
      if (result.state) {
        _currentUser = updatedUser;
        emit(AuthAuthenticated(updatedUser));
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
