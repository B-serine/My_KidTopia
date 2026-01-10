import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtopia_app/screens/sign_in.dart';
import 'package:kidtopia_app/logic/cubits/auth_cubit.dart';
import 'package:kidtopia_app/data/models/user.dart';
import 'package:kidtopia_app/data/models/result.dart';
import 'package:kidtopia_app/data/repositories/user_repository.dart';
import 'package:kidtopia_app/l10n/app_localizations.dart';

// Fake UserRepository for sign-in tests
class FakeUserRepository extends UserRepository {
  final Map<String, User> _store = {};

  void seed(User user) {
    if (user.name != null) _store[user.name!] = user;
  }

  @override
  Future<User?> getByName(String name) async => _store[name];
}

// Use the real AuthCubit but with injected FakeUserRepository
class TestAuthCubit extends AuthCubit {
  TestAuthCubit(FakeUserRepository repo) : super(repo);
}

void main() {
  testWidgets('SignIn form validation and success navigation', (
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

    final repo = FakeUserRepository();
    repo.seed(User(name: 'someuser', password: 'pass123'));
    final cubit = TestAuthCubit(repo);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: '/sign_in',
        routes: {
          '/': (_) => const SizedBox.shrink(),
          '/sign_in': (context) => BlocProvider<AuthCubit>.value(
            value: cubit,
            child: const SignInScreen(),
          ),
        },
      ),
    );

    // Fill fields and submit
    await tester.enterText(find.byType(TextFormField).at(0), 'someuser');
    await tester.enterText(find.byType(TextFormField).at(1), 'pass123');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(cubit.state, isA<AuthAuthenticated>());
  });
}
