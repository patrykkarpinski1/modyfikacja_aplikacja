part of 'category_page_cubit.dart';

@immutable
class CategoryPageState {
  final List<CategoryModel> categories;
  final bool isLoading;
  final String errorMessage;
  final CategoryModel? categoryModel;

  const CategoryPageState({
    this.categories = const [],
    this.isLoading = false,
    this.errorMessage = '',
    this.categoryModel,
  });
}
