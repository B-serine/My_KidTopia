// data/repositories/category_repository.dart
import 'package:kidtopia_app/data/models/category.dart';
import 'package:kidtopia_app/data/models/result.dart';
import 'package:kidtopia_app/data/repositories/base_repository.dart';

class CategoryRepository extends BaseRepository<Category> {
  @override
  String get tableName => 'categories';

  @override
  Map<String, dynamic> toMap(Category item) => item.toMap();

  @override
  Category fromMap(Map<String, dynamic> map) => Category.fromMap(map);

  @override
  ReturnResult? validate(Map<String, dynamic> record) {
    if (record['name'] == null || record['name'].toString().isEmpty) {
      return ReturnResult(state: false, message: 'Category name is required');
    }
    return null;
  }

  // Custom method: Get active categories only
  Future<List<Category>> getActiveCategories() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'is_active = ?',
      whereArgs: [1],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  // Custom method: Toggle category active status
  Future<ReturnResult> toggleActive(int categoryId) async {
    try {
      final db = await dbHelper.database;
      await db.rawUpdate(
        'UPDATE $tableName SET is_active = CASE WHEN is_active = 1 THEN 0 ELSE 1 END WHERE id = ?',
        [categoryId],
      );
      return ReturnResult(state: true, message: 'Category status toggled');
    } catch (e) {
      return ReturnResult(state: false, message: 'Error: ${e.toString()}');
    }
  }
}