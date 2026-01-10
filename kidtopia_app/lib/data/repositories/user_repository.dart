// data/repositories/user_repository.dart
import 'package:kidtopia_app/data/models/user.dart';
import 'package:kidtopia_app/data/models/result.dart';
import 'package:kidtopia_app/data/repositories/base_repository.dart';

class UserRepository extends BaseRepository<User> {
  @override
  String get tableName => 'users';

  @override
  Map<String, dynamic> toMap(User item) => item.toMap();

  @override
  User fromMap(Map<String, dynamic> map) => User.fromMap(map);

  @override
  ReturnResult? validate(Map<String, dynamic> record) {
    if (record['name'] == null || record['name'].toString().length <= 2) {
      return ReturnResult(state: false, message: 'Name length should be > 2');
    }
    if (record['password'] == null ||
        record['password'].toString().length < 4) {
      return ReturnResult(
        state: false,
        message: 'Password must be at least 4 characters',
      );
    }
    return null;
  }

  // Get user by name
  Future<User?> getByName(String name) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'LOWER(name) = ?',
      whereArgs: [name.toLowerCase()],
    );
    if (maps.isEmpty) return null;
    return fromMap(maps.first);
  }

  @override
  Future<ReturnResult> insertItem(Map<String, dynamic> record) async {
    try {
      final validationResult = validate(record);
      if (validationResult != null && !validationResult.state) {
        return validationResult;
      }

      // Ensure username uniqueness
      final existing = await getByName(record['name'].toString());
      if (existing != null) {
        return ReturnResult(state: false, message: 'Username already exists');
      }

      final db = await dbHelper.database;
      final id = await db.insert(tableName, record);
      return ReturnResult(
        state: true,
        message: 'Record inserted successfully',
        data: id,
      );
    } catch (e) {
      return ReturnResult(state: false, message: 'Error: ${e.toString()}');
    }
  }

  // Custom method: Update user score
  Future<ReturnResult> updateScore(int userId, int additionalPoints) async {
    try {
      final db = await dbHelper.database;
      await db.rawUpdate(
        'UPDATE $tableName SET total_score = total_score + ? WHERE id = ?',
        [additionalPoints, userId],
      );
      return ReturnResult(state: true, message: 'Score updated successfully');
    } catch (e) {
      return ReturnResult(state: false, message: 'Error: ${e.toString()}');
    }
  }

  // Custom method: Get premium users
  Future<List<User>> getPremiumUsers() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'is_premium = ?',
      whereArgs: [1],
    );
    return maps.map((map) => fromMap(map)).toList();
  }
}
