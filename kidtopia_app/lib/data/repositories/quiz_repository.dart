// data/repositories/quiz_repository.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kidtopia_app/data/models/quiz.dart';

class QuizRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  static const String tableName = 'quizzes';

  // Get all quizzes
  Future<List<Quiz>> getAll() async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .order('id', ascending: true);
      
      return (response as List)
          .map((map) => Quiz.fromMap(map))
          .toList();
    } catch (e) {
      print('Error fetching all quizzes: $e');
      return [];
    }
  }

  // Get quizzes by category
  Future<List<Quiz>> getByCategory(int categoryId) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('category_id', categoryId)
          .order('id', ascending: true);
      
      return (response as List)
          .map((map) => Quiz.fromMap(map))
          .toList();
    } catch (e) {
      print('Error fetching quizzes by category: $e');
      return [];
    }
  }

  // Get random quizzes by category (for quiz game)
  Future<List<Quiz>> getRandomQuizzes(int categoryId, {int limit = 10}) async {
    try {
      // Fetch all quizzes for the category
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('category_id', categoryId);
      
      final quizzes = (response as List)
          .map((map) => Quiz.fromMap(map))
          .toList();
      
      // Shuffle and take the limit
      quizzes.shuffle();
      
      if (quizzes.length <= limit) {
        return quizzes;
      }
      
      return quizzes.take(limit).toList();
    } catch (e) {
      print('Error fetching random quizzes: $e');
      return [];
    }
  }

  // Get quiz by id
  Future<Quiz?> getById(int id) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('id', id)
          .single();
      
      return Quiz.fromMap(response);
    } catch (e) {
      print('Error fetching quiz by id: $e');
      return null;
    }
  }

  // Count quizzes by category
  Future<int> countByCategory(int categoryId) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select('id')
          .eq('category_id', categoryId);
      
      return (response as List).length;
    } catch (e) {
      print('Error counting quizzes: $e');
      return 0;
    }
  }

  // Insert a new quiz (for admin app)
  Future<Quiz?> insert(Quiz quiz) async {
    try {
      final data = quiz.toMap();
      data.remove('id'); // Let Supabase auto-generate id
      
      final response = await _supabase
          .from(tableName)
          .insert(data)
          .select()
          .single();
      
      return Quiz.fromMap(response);
    } catch (e) {
      print('Error inserting quiz: $e');
      return null;
    }
  }

  // Update a quiz
  Future<Quiz?> update(Quiz quiz) async {
    try {
      if (quiz.id == null) return null;
      
      final response = await _supabase
          .from(tableName)
          .update(quiz.toMap())
          .eq('id', quiz.id!)
          .select()
          .single();
      
      return Quiz.fromMap(response);
    } catch (e) {
      print('Error updating quiz: $e');
      return null;
    }
  }

  // Delete a quiz
  Future<bool> delete(int id) async {
    try {
      await _supabase
          .from(tableName)
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      print('Error deleting quiz: $e');
      return false;
    }
  }

  // Upload image to Supabase Storage and return URL
  Future<String?> uploadImage(String filePath, String fileName) async {
    try {
      final file = await _readFileAsBytes(filePath);
      if (file == null) return null;

      final storagePath = 'quiz_images/$fileName';
      
      await _supabase.storage
          .from('quiz-images') // bucket name
          .uploadBinary(storagePath, file);

      // Get public URL
      final publicUrl = _supabase.storage
          .from('quiz-images')
          .getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Helper to read file as bytes
  Future<Uint8List?> _readFileAsBytes(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      print('Error reading file: $e');
      return null;
    }
  }

  // Get quizzes by level
  Future<List<Quiz>> getByLevel(int categoryId, int level) async {
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .eq('category_id', categoryId)
          .eq('level', level);
      
      return (response as List)
          .map((map) => Quiz.fromMap(map))
          .toList();
    } catch (e) {
      print('Error fetching quizzes by level: $e');
      return [];
    }
  }
}