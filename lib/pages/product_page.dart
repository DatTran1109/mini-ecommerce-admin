import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniecommerce_admin/bloc/product_bloc.dart';
import 'package:miniecommerce_admin/components/product_dialog.dart';
import 'package:miniecommerce_admin/components/product_tile.dart';
import 'package:miniecommerce_admin/data/ecommerce_provider.dart';
import 'package:miniecommerce_admin/data/models/product_model.dart';
import 'package:miniecommerce_admin/data/services/product_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _nameTextController = TextEditingController();
  final _descriptTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _sizeMTextController = TextEditingController();
  final _sizeLTextController = TextEditingController();
  final _sizeXLTextController = TextEditingController();
  final _sizeSTextController = TextEditingController();
  final _image1TextController = TextEditingController();
  final _image2TextController = TextEditingController();
  final _image3TextController = TextEditingController();
  final _image4TextController = TextEditingController();

  String _dropdownValue = '';
  final List<String> _categoryList = [];
  final List<String> _imageList = [];
  final Map<String, dynamic> _sizeMap = {};
  late Timer _timer;

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          _timer =
              Timer(const Duration(seconds: 2), () => Navigator.pop(context));

          return AlertDialog(
            title: Center(
              child: Text(
                message,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
            ),
          );
        }).whenComplete(() {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  void onCancel(BuildContext context) {
    Navigator.pop(context);
    _nameTextController.clear();
    _descriptTextController.clear();
    _priceTextController.clear();
    _sizeMTextController.clear();
    _sizeSTextController.clear();
    _sizeLTextController.clear();
    _sizeXLTextController.clear();
    _image1TextController.clear();
    _image2TextController.clear();
    _image3TextController.clear();
    _image4TextController.clear();
    _categoryList.clear();
    _imageList.clear();
    _sizeMap.clear();
  }

  void onUpdateSave(BuildContext context, ProductModel product) async {
    if (_nameTextController.text.trim().isEmpty ||
        _descriptTextController.text.trim().isEmpty ||
        _dropdownValue == '' ||
        _priceTextController.text.isEmpty) {
      showMessage('All fields are required');
    } else {
      _categoryList.add(_dropdownValue);
      _imageList
        ..add(_image1TextController.text.trim())
        ..add(_image2TextController.text.trim())
        ..add(_image3TextController.text.trim())
        ..add(_image4TextController.text.trim());
      _sizeMap['m'] = num.parse(_sizeMTextController.text);
      _sizeMap['l'] = num.parse(_sizeLTextController.text);
      _sizeMap['s'] = num.parse(_sizeSTextController.text);
      _sizeMap['xl'] = num.parse(_sizeXLTextController.text);

      final Map<String, dynamic> body = {
        'name': _nameTextController.text.trim(),
        'description': _descriptTextController.text.trim(),
        'price': num.parse(_priceTextController.text),
        'category': _categoryList,
        'size': _sizeMap,
        'image': _imageList,
      };

      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await ProductService.updateProduct(product.id, body)
            .whenComplete(() => Navigator.pop(context));

        onCancel(context);
        context.read<ProductBloc>().add(FetchAllProductEvent());
      } catch (e) {
        showMessage(e.toString());
      }
    }
  }

  void onCreateSave(BuildContext context) async {
    if (_nameTextController.text.trim().isEmpty ||
        _descriptTextController.text.trim().isEmpty ||
        _dropdownValue == '' ||
        _priceTextController.text.isEmpty) {
      showMessage('All fields are required');
    } else {
      _categoryList.add(_dropdownValue);
      _imageList
        ..add(_image1TextController.text.trim())
        ..add(_image2TextController.text.trim())
        ..add(_image3TextController.text.trim())
        ..add(_image4TextController.text.trim());
      _sizeMap['m'] = num.parse(_sizeMTextController.text);
      _sizeMap['l'] = num.parse(_sizeLTextController.text);
      _sizeMap['s'] = num.parse(_sizeSTextController.text);
      _sizeMap['xl'] = num.parse(_sizeXLTextController.text);

      final body = {
        'name': _nameTextController.text.trim(),
        'description': _descriptTextController.text.trim(),
        'price': num.parse(_priceTextController.text),
        'category': _categoryList,
        'size': _sizeMap,
        'image': _imageList,
      };

      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await ProductService.createProduct(body)
            .whenComplete(() => Navigator.pop(context));

        onCancel(context);
        context.read<ProductBloc>().add(FetchAllProductEvent());
      } catch (e) {
        showMessage(e.toString());
      }
    }
  }

  void deleteProduct(String id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Center(
                child: Text('Are you sure you want to delete this product'),
              ),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    try {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      await ProductService.deleteProduct(id)
                          .whenComplete(() => Navigator.pop(context));

                      Navigator.pop(context);
                      context.read<ProductBloc>().add(FetchAllProductEvent());
                    } catch (e) {
                      showMessage(e.toString());
                    }
                  },
                  child: const Text('Yes'),
                ),
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No'),
                ),
              ],
            ));
  }

  void updateProduct(ProductModel product) {
    _nameTextController.text = product.name;
    _descriptTextController.text = product.description;
    _priceTextController.text = product.price.toString();
    _dropdownValue = product.category![0].toString();
    _sizeMTextController.text = product.size!['m'].toString();
    _sizeLTextController.text = product.size!['l'].toString();
    _sizeSTextController.text = product.size!['s'].toString();
    _sizeXLTextController.text = product.size!['xl'].toString();
    _image1TextController.text = product.image![0].toString();
    _image2TextController.text = product.image![1].toString();
    _image3TextController.text = product.image![2].toString();
    _image4TextController.text = product.image![3].toString();

    showDialog(
        context: context,
        builder: (context) => ProductDialog(
            onSave: () => onUpdateSave(context, product),
            onCancel: () => onCancel(context),
            title: 'Edit product',
            dropdownValue: _dropdownValue,
            nameTextController: _nameTextController,
            descriptTextController: _descriptTextController,
            priceTextController: _priceTextController,
            sizeMTextController: _sizeMTextController,
            sizeLTextController: _sizeLTextController,
            sizeSTextController: _sizeSTextController,
            sizeXLTextController: _sizeXLTextController,
            image1TextController: _image1TextController,
            image2TextController: _image2TextController,
            image3TextController: _image3TextController,
            image4TextController: _image4TextController));
  }

  void createProduct() {
    _sizeMTextController.text = '0';
    _sizeLTextController.text = '0';
    _sizeSTextController.text = '0';
    _sizeXLTextController.text = '0';

    showDialog(
        context: context,
        builder: (context) => ProductDialog(
            onSave: () => onCreateSave(context),
            onCancel: () => onCancel(context),
            nameTextController: _nameTextController,
            title: 'Create new product',
            descriptTextController: _descriptTextController,
            priceTextController: _priceTextController,
            sizeMTextController: _sizeMTextController,
            sizeLTextController: _sizeLTextController,
            sizeSTextController: _sizeSTextController,
            sizeXLTextController: _sizeXLTextController,
            image1TextController: _image1TextController,
            image2TextController: _image2TextController,
            image3TextController: _image3TextController,
            image4TextController: _image4TextController));
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchAllProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    _dropdownValue = context.watch<EcommerceProvider>().category;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Center(child: Text('Product Management')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createProduct,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
        if (state is FetchAllProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FetchAllProductSuccess) {
          return ListView.builder(
              itemCount: state.productList.length,
              itemBuilder: (context, index) {
                return ProductTile(
                  productName: state.productList[index].name,
                  productPrice: state.productList[index].price.toString(),
                  imageUrl: state.productList[index].image![0],
                  deleteFunction: (context) =>
                      deleteProduct(state.productList[index].id),
                  updateFunction: (context) =>
                      updateProduct(state.productList[index]),
                );
              });
        } else if (state is FetchAllProductFailure) {
          return Center(child: Text(state.error));
        } else {
          return Container();
        }
      }),
    );
  }
}
