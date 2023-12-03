part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryStateInitial extends CategoryState {}

final class FetchAllCategoryLoading extends CategoryState {}

final class FetchAllCategoryFailure extends CategoryState {
  final String error;

  const FetchAllCategoryFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class FetchAllCategorySuccess extends CategoryState {
  final List<CategoryModel> categoryList;

  const FetchAllCategorySuccess(this.categoryList);

  @override
  List<Object> get props => [categoryList];
}
