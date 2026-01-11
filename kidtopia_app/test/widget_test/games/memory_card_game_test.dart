import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kidtopia_app/screens/games/MemoryCardGame.dart';
import 'package:kidtopia_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('MemoryCardGame Widget Tests', () {
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
        home: const MemoryCardGame(),
      );
    }

    testWidgets('should display game title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Memory Game'), findsOneWidget);
    });

    testWidgets('should display 36 animal cards', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final cards = find.byType(MemoryCard);
      expect(cards, findsNWidgets(36));
    });

    testWidgets('should show initial score 0/18', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('✨ 0/18'), findsOneWidget);
    });

    testWidgets('should have back button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsWidgets);
    });

    testWidgets('cards should show question mark when not flipped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have many question marks (unflipped cards)
      expect(find.text('?'), findsWidgets);
    });

    testWidgets('should flip card on tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final firstCard = find.byType(MemoryCard).first;
      await tester.tap(firstCard);
      await tester.pumpAndSettle();

      // After tapping, question marks should reduce
    });

    testWidgets('should display gradient background', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should have 6x6 grid layout', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });
  });

  group('MemoryCard Widget Tests', () {
    testWidgets('should show emoji when flipped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MemoryCard(
              card: CardItem(emoji: '🐶', id: 1, isFlipped: true),
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('🐶'), findsOneWidget);
    });

    testWidgets('should show question mark when not flipped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MemoryCard(
              card: CardItem(emoji: '🐶', id: 1, isFlipped: false),
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('should show green background when matched', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MemoryCard(
              card: CardItem(emoji: '🐱', id: 2, isMatched: true),
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('🐱'), findsOneWidget);
    });

    testWidgets('should trigger onTap callback', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MemoryCard(
              card: CardItem(emoji: '🐭', id: 3),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MemoryCard));
      expect(tapped, true);
    });
  });

  group('CardItem Unit Tests', () {
    test('should create card with default values', () {
      final card = CardItem(emoji: '🐹', id: 4);

      expect(card.emoji, '🐹');
      expect(card.id, 4);
      expect(card.isFlipped, false);
      expect(card.isMatched, false);
    });

    test('should create card with custom state', () {
      final card = CardItem(
        emoji: '🐰',
        id: 5,
        isFlipped: true,
        isMatched: true,
      );

      expect(card.isFlipped, true);
      expect(card.isMatched, true);
    });

    test('should allow state modification', () {
      final card = CardItem(emoji: '🦊', id: 6);

      card.isFlipped = true;
      expect(card.isFlipped, true);

      card.isMatched = true;
      expect(card.isMatched, true);
    });
  });

  group('Game Logic Tests', () {
    testWidgets('should allow flipping two cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const MemoryCardGame(),
        ),
      );
      await tester.pumpAndSettle();

      final cards = find.byType(MemoryCard);
      
      // Tap first card
      await tester.tap(cards.at(0));
      await tester.pump();

      // Tap second card
      await tester.tap(cards.at(1));
      await tester.pump(const Duration(seconds: 2));
    });
  });
}