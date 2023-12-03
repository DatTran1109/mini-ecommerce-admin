part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductStateInitial extends ProductState {}

final class FetchAllProductLoading extends ProductState {}

final class FetchAllProductFailure extends ProductState {
  final String error;

  const FetchAllProductFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class FetchAllProductSuccess extends ProductState {
  final List<ProductModel> productList;

  const FetchAllProductSuccess(this.productList);

  @override
  List<Object> get props => [productList];
}
