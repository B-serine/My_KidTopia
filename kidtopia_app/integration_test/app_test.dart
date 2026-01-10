import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:kidtopia_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app starts and shows splash/database init', (
    WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // The app shows either splash or main app after init; ensure no exceptions
    expect(find.byType(Scaffold), findsWidgets);
  });
}
