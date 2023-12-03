import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:miniecommerce_admin/data/models/category_model.dart';
import 'package:miniecommerce_admin/data/services/category_service.dart';
part 'category_state.dart';
part 'category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryStateInitial()) {
    // on<UserSignInEvent>((event, emit) {
    //   emit(UserSignInSuccess(event.userEmail));
    // });

    on<FetchAllCategoryEvent>((event, emit) async {
      emit(FetchAllCategoryLoading());

      try {
        List<CategoryModel> categoryList =
            await CategoryService.fetchAllCategory();

        emit(FetchAllCategorySuccess(categoryList));
      } catch (e) {
        emit(FetchAllCategoryFailure(e.toString()));
      }
    });

    // on<FetchAllProductEvent>((event, emit) async {
    //   emit(FetchAllProductLoading());

    //   try {
    //     List<ProductModel> productList = await ProductService.fetchAllProduct();

    //     emit(FetchAllProductSuccess(productList));
    //   } catch (e) {
    //     emit(FetchAllProductFailure(e.toString()));
    //   }
    // });

    // on<SelectCategoryEvent>((event, emit) {
    //   emit(SelectCategorySuccess(event.category));
    // });
  }
}
