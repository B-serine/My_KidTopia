import 'package:flutter_test/flutter_test.dart';
import 'package:kidtopia_app/models/category.dart';
import 'package:kidtopia_app/models/answer.dart';
import 'package:kidtopia_app/models/question.dart';
import 'package:kidtopia_app/models/profile.dart';

void main() {
  group('Category', () {
    final json = {
      'id': 1,
      'name': 'Animals',
      'description': 'All about animals',
      'image_url': 'http://example.com/a.png',
      'color': '#FFFFFF',
      'is_active': false,
      'required_score': 10,
      'is_premium': true,
    };

    test('fromJson and toJson roundtrip', () {
      final c = Category.fromJson(json);
      expect(c.id, 1);
      expect(c.name, 'Animals');
      expect(c.isActive, false);
      final out = c.toJson();
      expect(out['id'], 1);
      expect(out['name'], 'Animals');
      expect(out['is_active'], false);
      expect(out['is_premium'], true);
    });

    test('copyWith and equality', () {
      final c = Category.fromJson(json);
      final c2 = c.copyWith(name: 'New');
      expect(c2.name, 'New');
      // equality is based on id
      final sameId = Category(id: 1);
      expect(c, sameId);
    });
  });

  group('Answer', () {
    final json = {
      'id': 5,
      'question_id': 2,
      'answer_text': 'Blue',
      'is_correct': true,
      'display_order': 3,
    };

    test('fromJson and toJson roundtrip', () {
      final a = Answer.fromJson(json);
      expect(a.id, 5);
      expect(a.questionId, 2);
      expect(a.answerText, 'Blue');
      expect(a.isCorrect, true);
      final out = a.toJson();
      expect(out['id'], 5);
      expect(out['answer_text'], 'Blue');
      expect(out['is_correct'], true);
    });

    test('copyWith and equality', () {
      final a = Answer.fromJson(json);
      final a2 = a.copyWith(answerText: 'Red');
      expect(a2.answerText, 'Red');
      final sameId = Answer(id: 5, questionId: 2, answerText: 'X');
      expect(a, sameId);
    });
  });

  group('Question', () {
    final json = {
      'id': 7,
      'category_id': 3,
      'question_text': 'What color?',
      'image_url': null,
      'level': 2,
      'points': 15,
    };

    test('fromJson and toJson roundtrip', () {
      final q = Question.fromJson(json);
      expect(q.id, 7);
      expect(q.categoryId, 3);
      expect(q.questionText, 'What color?');
      expect(q.level, 2);
      expect(q.points, 15);
      final out = q.toJson();
      expect(out['id'], 7);
      expect(out['question_text'], 'What color?');
    });

    test('copyWith and equality', () {
      final q = Question.fromJson(json);
      final q2 = q.copyWith(points: 20);
      expect(q2.points, 20);
      final sameId = Question(id: 7, categoryId: 3, questionText: 'x');
      expect(q, sameId);
    });
  });

  group('Profile', () {
    final json = {
      'id': 'uuid-1',
      'name': 'Alice',
      'username': 'alice',
      'password': 'pass',
      'age': 10,
      'avatar_url': 'http://x',
      'total_score': 42,
      'is_premium': true,
      'fcm_token': 'tok',
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson and toJson roundtrip', () {
      final p = Profile.fromJson(json);
      expect(p.id, 'uuid-1');
      expect(p.username, 'alice');
      expect(p.age, 10);
      expect(p.totalScore, 42);
      expect(p.isPremium, true);
      final out = p.toJson();
      expect(out['id'], 'uuid-1');
      expect(out['username'], 'alice');
      expect(out['total_score'], 42);
      expect(out['created_at'], '2024-01-01T00:00:00.000Z');
    });

    test('copyWith and equality', () {
      final p = Profile.fromJson(json);
      final p2 = p.copyWith(name: 'Bob');
      expect(p2.name, 'Bob');
      final same = Profile(id: 'uuid-1');
      // equality compares id and username
      expect(Profile(id: 'uuid-1', username: p.username), p);
      expect(p, p);
      expect(p.hashCode, isA<int>());
    });
  });
}
