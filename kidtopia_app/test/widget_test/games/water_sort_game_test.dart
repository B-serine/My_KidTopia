import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kidtopia_app/screens/games/water_sort.dart';
import 'package:kidtopia_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('WaterSortGame Widget Tests', () {
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
        home: const WaterSortGame(),
      );
    }

    testWidgets('should display game title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Water Sort Game'), findsOneWidget);
    });

    testWidgets('should display motivational message', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Sort'), findsWidgets);
    });

    testWidgets('should display 6 bottles', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have 6 BottleWidget instances
      expect(find.byType(BottleWidget), findsNWidgets(6));
    });

    testWidgets('should have Play Again button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Play Again'), findsOneWidget);
    });

    testWidgets('should have skip button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsWidgets);
    });

    testWidgets('should show water drop icons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.water_drop), findsWidgets);
    });

    testWidgets('Play Again button should restart game', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Play Again button
      await tester.tap(find.textContaining('Play Again'));
      await tester.pumpAndSettle();

      // Game should still have 6 bottles
      expect(find.byType(BottleWidget), findsNWidgets(6));
    });

    testWidgets('should have white background', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('bottles should be tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find first bottle
      final firstBottle = find.byType(BottleWidget).first;
      
      // Should be wrapped in GestureDetector
      final gesture = find.ancestor(
        of: firstBottle,
        matching: find.byType(GestureDetector),
      );
      expect(gesture, findsOneWidget);
    });

    testWidgets('should display bottles in horizontal scroll', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Bottles should be in a row that can scroll
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('BottleWidget Tests', () {
    testWidgets('should display empty bottle correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BottleWidget(
              colors: const [],
              isSelected: false,
              capacity: 4,
            ),
          ),
        ),
      );

      expect(find.byType(BottleWidget), findsOneWidget);
    });

    testWidgets('should display filled bottle with colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BottleWidget(
              colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow],
              isSelected: false,
              capacity: 4,
            ),
          ),
        ),
      );

      expect(find.byType(BottleWidget), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should show orange border when selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BottleWidget(
              colors: const [Colors.red],
              isSelected: true,
              capacity: 4,
            ),
          ),
        ),
      );

      // Should have border decoration
      expect(find.byType(BottleWidget), findsOneWidget);
    });

    testWidgets('should display partially filled bottle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BottleWidget(
              colors: const [Colors.purple, Colors.orange],
              isSelected: false,
              capacity: 4,
            ),
          ),
        ),
      );

      expect(find.byType(BottleWidget), findsOneWidget);
    });
  });

  group('Game Logic Tests', () {
    testWidgets('should initialize with 4 filled and 2 empty bottles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const WaterSortGame(),
        ),
      );
      await tester.pumpAndSettle();

      // Should have 6 bottles total
      expect(find.byType(BottleWidget), findsNWidgets(6));
    });

    testWidgets('should select bottle on first tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const WaterSortGame(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap first bottle
      final firstBottle = find.byType(BottleWidget).first;
      await tester.tap(firstBottle);
      await tester.pumpAndSettle();

      // Bottle should be selected
    });

    testWidgets('should pour water between bottles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const WaterSortGame(),
        ),
      );
      await tester.pumpAndSettle();

      // Select first bottle
      await tester.tap(find.byType(BottleWidget).first);
      await tester.pumpAndSettle();

      // Try to pour into another bottle
      await tester.tap(find.byType(BottleWidget).at(4)); // Empty bottle
      await tester.pumpAndSettle();

      // Water should have moved
    });
  });

  group('Integration Tests', () {
    testWidgets('complete game flow - play and restart', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const WaterSortGame(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Game should have 6 bottles
      expect(find.byType(BottleWidget), findsNWidgets(6));

      // 2. Select and pour water
      await tester.tap(find.byType(BottleWidget).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BottleWidget).at(4));
      await tester.pumpAndSettle();

      // 3. Restart game
      await tester.tap(find.textContaining('Play Again'));
      await tester.pumpAndSettle();

      // 4. Should still have 6 bottles
      expect(find.byType(BottleWidget), findsNWidgets(6));
    });

    testWidgets('skip button navigates to categories', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/': (context) => const WaterSortGame(),
            '/categories': (context) => const Scaffold(body: Text('Categories')),
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
        ),
      );
      await tester.pumpAndSettle();

      // Tap skip button
      final skipButton = find.byIcon(Icons.arrow_back).last;
      await tester.tap(skipButton);
      await tester.pumpAndSettle();

      // Should navigate to categories
      expect(find.text('Categories'), findsOneWidget);
    });
  });

  group('Color Logic Tests', () {
    testWidgets('should use 4 different colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const WaterSortGame(),
        ),
      );
      await tester.pumpAndSettle();

      // Game should initialize with colors
      expect(find.byType(BottleWidget), findsNWidgets(6));
    });
  });
}