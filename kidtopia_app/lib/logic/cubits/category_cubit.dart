import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/category.dart';
import '../../data/repositories/category_repository.dart';

// ==================== STATES ====================
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

// ==================== CUBIT ====================
class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryCubit(this._categoryRepository) : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await _categoryRepository.getAll();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> loadActiveCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await _categoryRepository.getActiveCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load active categories: ${e.toString()}'));
    }
  }

  Future<Category?> getCategoryById(int id) async {
    try {
      return await _categoryRepository.getById(id);
    } catch (e) {
      emit(CategoryError('Failed to get category: ${e.toString()}'));
      return null;
    }
  }
}
