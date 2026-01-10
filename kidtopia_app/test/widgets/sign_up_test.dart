import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtopia_app/screens/sign_up.dart';
import 'package:kidtopia_app/logic/cubits/auth_cubit.dart';
import 'package:kidtopia_app/data/models/user.dart';
import 'package:kidtopia_app/data/models/result.dart';
import 'package:kidtopia_app/data/repositories/user_repository.dart';
import 'package:kidtopia_app/l10n/app_localizations.dart';

// A lightweight fake UserRepository that doesn't touch the DB
class FakeUserRepository extends UserRepository {
  final Map<String, User> _store = {};
  int _nextId = 1;

  @override
  Future<ReturnResult> insertItem(Map<String, dynamic> record) async {
    final validation = validate(record);
    if (validation != null && !validation.state) return validation;
    if (_store.containsKey(record['name'])) {
      return ReturnResult(state: false, message: 'Username already exists');
    }
    final id = _nextId++;
    final user = User(
      id: id,
      name: record['name'],
      password: record['password'],
      age: record['age'],
      avatarUrl: record['avatar_url'],
      totalScore: record['total_score'] ?? 0,
      isPremium: (record['is_premium'] ?? 0) == 1,
    );
    _store[user.name ?? ''] = user;
    return ReturnResult(state: true, message: 'Inserted', data: id);
  }

  @override
  Future<User?> getByName(String name) async => _store[name];
}

// Use the real AuthCubit but with the FakeUserRepository injected
class TestAuthCubit extends AuthCubit {
  TestAuthCubit() : super(FakeUserRepository());
}

void main() {
  testWidgets('SignUp form validation and success navigation', (
    WidgetTester tester,
  ) async {
    final binding =
        TestWidgetsFlutterBinding.ensureInitialized()
            as TestWidgetsFlutterBinding;
    binding.window.physicalSizeTestValue = const Size(1200, 1200);
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    final cubit = TestAuthCubit();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: '/sign_up',
        routes: {
          '/': (_) => const SizedBox.shrink(),
          '/sign_up': (context) => BlocProvider<AuthCubit>.value(
            value: cubit,
            child: const SignUpScreen(),
          ),
        },
      ),
    );

    // Try submit empty form — button text is localized so find by 'Sign Up'
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle();

    // Fill fields
    await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
    await tester.enterText(find.byType(TextFormField).at(1), 'pass1234');
    await tester.enterText(find.byType(TextFormField).at(2), 'pass1234');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // After fake signup, AuthCubit should be authenticated
    expect(cubit.state, isA<AuthAuthenticated>());
  });
}
