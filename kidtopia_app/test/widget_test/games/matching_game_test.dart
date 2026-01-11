import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kidtopia_app/screens/games/MatchingGame.dart';
import 'package:kidtopia_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('MatchingGame Widget Tests', () {
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
        home: const MatchingGame(),
      );
    }

    testWidgets('should display timer and level on start', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for level indicator
      expect(find.textContaining('Level'), findsOneWidget);
      
      // Check for timer (should show 60 initially)
      expect(find.textContaining('60'), findsOneWidget);
    });

    testWidgets('should display draggable items', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for draggable items
      expect(find.byType(Draggable<GameItem>), findsWidgets);
    });

    testWidgets('should display baskets at bottom', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for drag targets (baskets)
      expect(find.byType(DragTarget<GameItem>), findsWidgets);
    });

    testWidgets('should start at level 1', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Level 1'), findsOneWidget);
    });

    testWidgets('timer should be visible', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Timer emoji should be visible
      expect(find.text('⏱️'), findsOneWidget);
    });

    testWidgets('should show items in grid layout', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for GridView
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should show baskets in horizontal list', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for horizontal ListView for baskets
      final listViews = find.byType(ListView);
      expect(listViews, findsOneWidget);
    });

    testWidgets('skip button should be visible', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final skipButtons = find.byIcon(Icons.arrow_back);
      expect(skipButtons, findsWidgets);
    });
  });

  group('GameItem Unit Tests', () {
    test('should create GameItem with correct properties', () {
      final item = GameItem(
        emoji: '🍎',
        type: 'apple',
        index: 0,
      );

      expect(item.emoji, '🍎');
      expect(item.type, 'apple');
      expect(item.index, 0);
      expect(item.isMatched, false);
    });

    test('should allow setting isMatched', () {
      final item = GameItem(
        emoji: '🍌',
        type: 'banana',
        index: 1,
        isMatched: true,
      );

      expect(item.isMatched, true);
    });
  });

  group('Basket Unit Tests', () {
    test('should create Basket with correct properties', () {
      final basket = Basket(
        emoji: '🧺',
        type: 'apple',
        label: '🍎',
        index: 0,
      );

      expect(basket.emoji, '🧺');
      expect(basket.type, 'apple');
      expect(basket.label, '🍎');
      expect(basket.index, 0);
      expect(basket.count, 0);
    });

    test('should increment count', () {
      final basket = Basket(
        emoji: '🧺',
        type: 'banana',
        label: '🍌',
        index: 1,
      );

      basket.count++;
      expect(basket.count, 1);

      basket.count++;
      expect(basket.count, 2);
    });
  });

  group('Level Data Tests', () {
    testWidgets('should load level 1 correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const MatchingGame(),
        ),
      );
      await tester.pumpAndSettle();

      // Level 1 should have 60 seconds
      expect(find.textContaining('60'), findsOneWidget);
      expect(find.text('Level 1'), findsOneWidget);
    });
  });
}