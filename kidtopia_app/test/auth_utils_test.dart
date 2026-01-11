import 'package:flutter_test/flutter_test.dart';
import 'package:kidtopia_app/core/auth_utils.dart';

void main() {
  test('hash and verify password', () {
    final pw = 'supersecret';
    final result = AuthUtils.hashPassword(pw);
    expect(result.containsKey('salt'), isTrue);
    expect(result.containsKey('hash'), isTrue);

    final stored = '${result['salt']}:${result['hash']}';
    expect(AuthUtils.verifyPassword(pw, stored), isTrue);
    expect(AuthUtils.verifyPassword('wrong', stored), isFalse);
  });

  test('different salts produce different hashes', () {
    final a = AuthUtils.hashPassword('pw');
    final b = AuthUtils.hashPassword('pw');
    expect(a['salt'], isNot(b['salt']));
    expect(a['hash'], isNot(b['hash']));
  });
}
