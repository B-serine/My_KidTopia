// data/repositories/question_repository.dart
import 'package:kidtopia_app/data/models/question.dart';
import 'package:kidtopia_app/data/models/result.dart';
import 'package:kidtopia_app/data/repositories/base_repository.dart';

class QuestionRepository extends BaseRepository<Question> {
  @override
  String get tableName => 'questions';

  @override
  Map<String, dynamic> toMap(Question item) => item.toMap();

  @override
  Question fromMap(Map<String, dynamic> map) => Question.fromMap(map);

  @override
  ReturnResult? validate(Map<String, dynamic> record) {
    if (record['question_text'] == null || record['question_text'].toString().isEmpty) {
      return ReturnResult(state: false, message: 'Question text is required');
    }
    if (record['category_id'] == null) {
      return ReturnResult(state: false, message: 'Category is required');
    }
    return null;
  }

  // Custom method: Get questions by category
  Future<List<Question>> getByCategory(int categoryId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  // Custom method: Get questions by level
  Future<List<Question>> getByLevel(int level) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'level = ?',
      whereArgs: [level],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  // Custom method: Get questions by category and level
  Future<List<Question>> getByCategoryAndLevel(int categoryId, int level) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'category_id = ? AND level = ?',
      whereArgs: [categoryId, level],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  // Custom method: Get random questions for quiz
  Future<List<Question>> getRandomQuestions(int categoryId, int limit) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM $tableName WHERE category_id = ? ORDER BY RANDOM() LIMIT ?',
      [categoryId, limit],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  // Custom method: Count questions by category
  Future<int> countByCategory(int categoryId) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE category_id = ?',
      [categoryId],
    );
    return result.first['count'] as int? ?? 0;
  }
}