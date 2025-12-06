// data/repositories/answer_repository.dart
import 'package:kidtopia_app/data/models/answer.dart';
import 'package:kidtopia_app/data/models/result.dart';
import 'package:kidtopia_app/data/repositories/base_repository.dart';

class AnswerRepository extends BaseRepository<Answer> {
  @override
  String get tableName => 'answers';

  @override
  Map<String, dynamic> toMap(Answer item) => item.toMap();

  @override
  Answer fromMap(Map<String, dynamic> map) => Answer.fromMap(map);

  @override
  ReturnResult? validate(Map<String, dynamic> record) {
    if (record['answer_text'] == null || record['answer_text'].toString().isEmpty) {
      return ReturnResult(state: false, message: 'Answer text is required');
    }
    if (record['question_id'] == null) {
      return ReturnResult(state: false, message: 'Question ID is required');
    }
    return null;
  }

  // Custom method: Get answers by question
  Future<List<Answer>> getByQuestion(int questionId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'question_id = ?',
      whereArgs: [questionId],
      orderBy: 'display_order ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  // Custom method: Get correct answer for a question
  Future<Answer?> getCorrectAnswer(int questionId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'question_id = ? AND is_correct = ?',
      whereArgs: [questionId, 1],
    );
    if (maps.isEmpty) return null;
    return fromMap(maps.first);
  }

  // Custom method: Check if answer is correct
  Future<bool> isCorrect(int answerId) async {
    final answer = await getById(answerId);
    return answer?.isCorrect ?? false;
  }

  // Custom method: Delete all answers for a question
  Future<ReturnResult> deleteByQuestion(int questionId) async {
    try {
      final db = await dbHelper.database;
      final rowsDeleted = await db.delete(
        tableName,
        where: 'question_id = ?',
        whereArgs: [questionId],
      );
      return ReturnResult(
        state: true,
        message: '$rowsDeleted answers deleted successfully',
      );
    } catch (e) {
      return ReturnResult(state: false, message: 'Error: ${e.toString()}');
    }
  }

  // Custom method: Insert multiple answers for a question
  Future<ReturnResult> insertAnswers(List<Map<String, dynamic>> answers) async {
    try {
      final db = await dbHelper.database;
      await db.transaction((txn) async {
        for (final answer in answers) {
          await txn.insert(tableName, answer);
        }
      });
      return ReturnResult(
        state: true,
        message: '${answers.length} answers inserted successfully',
      );
    } catch (e) {
      return ReturnResult(state: false, message: 'Error: ${e.toString()}');
    }
  }
}