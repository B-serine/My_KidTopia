import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class AuthUtils {
  /// Generate a base64 salt of [length] bytes
  static String generateSalt([int length = 16]) {
    final r = Random.secure();
    final bytes = List<int>.generate(length, (_) => r.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Hash [password] with [salt] using SHA-256
  static String hashWithSalt(String password, String salt) {
    final bytes = utf8.encode(salt + password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Convenience to create salt and hash
  /// Returns map {'salt': ..., 'hash': ...}
  static Map<String, String> hashPassword(String password) {
    final salt = generateSalt();
    final hash = hashWithSalt(password, salt);
    return {'salt': salt, 'hash': hash};
  }

  /// Verify stored string 'salt:hash' or provided separate values
  static bool verifyPassword(String plain, String stored) {
    final parts = stored.split(':');
    if (parts.length != 2) return false;
    final salt = parts[0];
    final hash = parts[1];
    return hashWithSalt(plain, salt) == hash;
  }
}
