// data/repositories/base_repository.dart
import 'package:kidtopia_app/data/models/result.dart';
import 'package:kidtopia_app/data/databases/db_helper.dart';

abstract class BaseRepository<T> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  
  // Abstract getters that child classes must implement
  String get tableName;
  
  // Convert model to map for database operations
  Map<String, dynamic> toMap(T item);
  
  // Convert map from database to model
  T fromMap(Map<String, dynamic> map);
  
  // Validate item before insert/update (override in child classes)
  ReturnResult? validate(Map<String, dynamic> record) => null;
  
  // Get all items
  Future<List<T>> getAll() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => fromMap(map)).toList();
  }
  
  // Get all items as raw maps
  Future<List<Map<String, dynamic>>> getData() async {
    final db = await dbHelper.database;
    return await db.query(tableName);
  }
  
  // Get item by id
  Future<T?> getById(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return fromMap(maps.first);
  }
  
  // Insert item
  Future<ReturnResult> insertItem(Map<String, dynamic> record) async {
    try {
      // Run validation if implemented
      final validationResult = validate(record);
      if (validationResult != null && !validationResult.state) {
        return validationResult;
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
  
  // Update item
  Future<ReturnResult> updateItem(Map<String, dynamic> record) async {
    try {
      // Run validation if implemented
      final validationResult = validate(record);
      if (validationResult != null && !validationResult.state) {
        return validationResult;
      }
      
      final db = await dbHelper.database;
      final rowsUpdated = await db.update(
        tableName,
        record,
        where: 'id = ?',
        whereArgs: [record['id']],
      );
      
      if (rowsUpdated > 0) {
        return ReturnResult(state: true, message: 'Record updated successfully');
      }
      return ReturnResult(state: false, message: 'Record not found');
    } catch (e) {
      return ReturnResult(state: false, message: 'Error: ${e.toString()}');
    }
  }
  
  // Delete item
  Future<ReturnResult> deleteItem(int id) async {
    try {
      final db = await dbHelper.database;
      final rowsDeleted = await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (rowsDeleted > 0) {
        return ReturnResult(
          state: true,
          message: 'Record of id ($id) deleted successfully',
        );
      }
      return ReturnResult(state: false, message: 'Item could not be deleted');
    } catch (e) {
      return ReturnResult(state: false, message: 'Error: ${e.toString()}');
    }
  }
}