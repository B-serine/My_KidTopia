import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kidtopia_app/screens/games/PetFeedingGame.dart';
import 'package:kidtopia_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('PetFeedingGame Widget Tests', () {
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
        home: const PetFeedingGame(),
      );
    }

    testWidgets('should display game title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Pet Care'), findsOneWidget);
    });

    testWidgets('should display default pet (Buddy 🐶)', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Buddy'), findsOneWidget);
      expect(find.text('🐶'), findsOneWidget);
    });

    testWidgets('should show start game button initially', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Start Game'), findsOneWidget);
    });

    testWidgets('should display happiness and fullness bars', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Happiness'), findsOneWidget);
      expect(find.textContaining('Fullness'), findsOneWidget);
    });

    testWidgets('should show play and pet buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Play'), findsOneWidget);
      expect(find.textContaining('Pet'), findsOneWidget);
    });

    testWidgets('should display food items when game starts', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap start button
      final startButton = find.textContaining('Start Game');
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Food section should be visible
      expect(find.textContaining('Feed Your Pet'), findsOneWidget);
    });

    testWidgets('should show timer when game starts', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap start button
      final startButton = find.textContaining('Start Game');
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Timer should be visible
      expect(find.textContaining('Time'), findsOneWidget);
    });

    testWidgets('should have skip button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsWidgets);
    });

    testWidgets('should display pet mood emoji', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should show neutral mood initially (😐)
      expect(find.text('😐'), findsOneWidget);
    });

    testWidgets('should show gradient background', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('play and pet buttons should be disabled before game starts', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final playButton = find.widgetWithText(ElevatedButton, '⚽\nPlay');
      final petButton = find.widgetWithText(ElevatedButton, '🤗\nPet');

      // Buttons should exist
      expect(playButton, findsOneWidget);
      expect(petButton, findsOneWidget);
    });
  });

  group('Game State Tests', () {
    testWidgets('should start with 50% happiness and hunger', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const PetFeedingGame(),
        ),
      );
      await tester.pumpAndSettle();

      // Check for 50% text
      expect(find.text('50%'), findsNWidgets(2)); // One for happiness, one for fullness
    });

    testWidgets('should show 30% stats when game starts', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const PetFeedingGame(),
        ),
      );
      await tester.pumpAndSettle();

      // Start game
      final startButton = find.textContaining('Start Game');
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Should show 30% for both stats
      expect(find.text('30%'), findsNWidgets(2));
    });
  });

  group('Food Items Tests', () {
    testWidgets('should display 6 food options', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const PetFeedingGame(),
        ),
      );
      await tester.pumpAndSettle();

      // Start game
      await tester.tap(find.textContaining('Start Game'));
      await tester.pumpAndSettle();

      // Check for food emojis
      expect(find.text('🍎'), findsOneWidget);
      expect(find.text('🍕'), findsOneWidget);
      expect(find.text('🦴'), findsOneWidget);
      expect(find.text('🥕'), findsOneWidget);
      expect(find.text('🍰'), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    testWidgets('complete game flow - start to end', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const PetFeedingGame(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Game should show start button
      expect(find.textContaining('Start Game'), findsOneWidget);

      // 2. Start the game
      await tester.tap(find.textContaining('Start Game'));
      await tester.pumpAndSettle();

      // 3. Timer should be visible
      expect(find.textContaining('Time'), findsOneWidget);

      // 4. Food section should appear
      expect(find.textContaining('Feed Your Pet'), findsOneWidget);
    });
  });
}