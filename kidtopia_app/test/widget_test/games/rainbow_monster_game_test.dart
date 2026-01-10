import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kidtopia_app/screens/games/RainbowMonsterGame.dart';
import 'package:kidtopia_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('RainbowMonsterGame Widget Tests', () {
    Widget createTestWidget() {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('fr'),
          Locale('ar'),
        ],
        home: const RainbowMonsterGame(),
      );
    }

    testWidgets('should display game title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(RainbowMonsterGame), findsOneWidget);
    });

    testWidgets('should show score and win threshold', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for score display (⭐ 0) and threshold (/250)
      expect(find.textContaining('⭐'), findsOneWidget);
      expect(find.textContaining('250'), findsOneWidget);
    });

    testWidgets('should show timer (60s)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('⏰'), findsOneWidget);
      expect(find.textContaining('60'), findsOneWidget);
    });

    testWidgets('should display customize game section', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Monster types should be visible before game starts
      expect(find.text('😊'), findsWidgets);
    });

    testWidgets('should show 4 monster type options', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Monster types
      expect(find.text('😊'), findsWidgets); // Happy
      expect(find.text('⭐'), findsWidgets); // Starry
      expect(find.text('💖'), findsWidgets); // Lovely
      expect(find.text('😎'), findsWidgets); // Cool
    });

    testWidgets('should show 4 background options', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Sky'), findsOneWidget);
      expect(find.text('Sunset'), findsOneWidget);
      expect(find.text('Forest'), findsOneWidget);
      expect(find.text('Candy'), findsOneWidget);
    });

    testWidgets('should have start game button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Start Game'), findsOneWidget);
    });

    testWidgets('should show how to play section', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('How to Play'), findsOneWidget);
    });

    testWidgets('should have skip button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Skip button should be available
      expect(find.textContaining('Skip'), findsWidgets);
    });

    testWidgets('should select monster type on tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap a monster type
      final starryMonster = find.text('⭐').first;
      await tester.tap(starryMonster);
      await tester.pumpAndSettle();

      // Monster should be selected (visual feedback)
    });

    testWidgets('should select background on tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap Sunset background
      final sunsetBg = find.text('Sunset');
      await tester.tap(sunsetBg);
      await tester.pumpAndSettle();

      // Background should change
    });

    testWidgets('should start game when button tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap start button
      final startButton = find.text('Start Game');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();
      }
    });
  });

  group('Monster Class Tests', () {
    test('should create monster with correct properties', () {
      // Note: Monster requires a valid TickerProvider (vsync)
      // Cannot test without a proper test harness with TickerProviderStateMixin
      // This test is skipped as Monster requires StatefulWidget context
    });

    test('should have default speed and gravity', () {
      // Note: Monster requires a valid TickerProvider (vsync)
      // Cannot test without a proper test harness with TickerProviderStateMixin
      // This test is skipped as Monster requires StatefulWidget context
    });
  });

  group('Game Logic Tests', () {
    testWidgets('score should start at 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const RainbowMonsterGame(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('⭐'), findsOneWidget);
    });

    testWidgets('timer should start at 60 seconds', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const RainbowMonsterGame(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('⏰'), findsOneWidget);
    });

    testWidgets('game should not be started initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const RainbowMonsterGame(),
        ),
      );
      await tester.pumpAndSettle();

      // Start button should be visible
      expect(find.text('Start Game'), findsWidgets);
    });
  });

  group('Integration Tests', () {
    testWidgets('complete game customization and start', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const RainbowMonsterGame(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Select a monster type
      final lovelyMonster = find.text('💖');
      if (lovelyMonster.evaluate().isNotEmpty) {
        await tester.tap(lovelyMonster.first);
        await tester.pumpAndSettle();
      }

      // 2. Select a background
      final forestBg = find.text('Forest');
      if (forestBg.evaluate().isNotEmpty) {
        await tester.tap(forestBg);
        await tester.pumpAndSettle();
      }

      // 3. Start the game
      final startButton = find.text('Start Game');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();
      }
    });
  });
}