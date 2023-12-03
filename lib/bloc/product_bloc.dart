import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:miniecommerce_admin/data/models/product_model.dart';
import 'package:miniecommerce_admin/data/services/product_service.dart';
part 'product_state.dart';
part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductStateInitial()) {
    on<FetchAllProductEvent>((event, emit) async {
      emit(FetchAllProductLoading());

      try {
        List<ProductModel> productList = await ProductService.fetchAllProduct();

        emit(FetchAllProductSuccess(productList));
      } catch (e) {
        emit(FetchAllProductFailure(e.toString()));
      }
    });
  }
}
