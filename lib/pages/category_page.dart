import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniecommerce_admin/bloc/category_bloc.dart';
import 'package:miniecommerce_admin/components/category_dialog.dart';
import 'package:miniecommerce_admin/components/category_tile.dart';
import 'package:miniecommerce_admin/data/services/category_service.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _nameTextController = TextEditingController();
  final _iconTextController = TextEditingController();
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

  void deleteCategory(String id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Center(
                child: Text('Are you sure you want to delete this category'),
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

                      await CategoryService.deleteCategory(id)
                          .whenComplete(() => Navigator.pop(context));

                      Navigator.pop(context);
                      context.read<CategoryBloc>().add(FetchAllCategoryEvent());
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

  void updateCategory(String id, String nameText, String iconText) {
    _nameTextController.text = nameText;
    _iconTextController.text = iconText;
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(
        title: 'Edit category',
        onSave: () async {
          if (_nameTextController.text.trim().isEmpty ||
              _iconTextController.text.trim().isEmpty) {
            showMessage('All fields are required');
          } else {
            showDialog(
              context: context,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );

            try {
              await CategoryService.updateCategory(
                      id, _nameTextController.text, _iconTextController.text)
                  .whenComplete(() => Navigator.pop(context));

              Navigator.pop(context);
              _nameTextController.clear();
              _iconTextController.clear();
              context.read<CategoryBloc>().add(FetchAllCategoryEvent());
            } catch (e) {
              showMessage(e.toString());
            }
          }
        },
        onCancel: () {
          Navigator.pop(context);
          _nameTextController.clear();
          _iconTextController.clear();
        },
        nameTextController: _nameTextController,
        iconTextcontroller: _iconTextController,
      ),
    );
  }

  void createCategory() {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(
        title: 'Create new category',
        onSave: () async {
          if (_nameTextController.text.trim().isEmpty ||
              _iconTextController.text.trim().isEmpty) {
            showMessage('All fields are required');
          } else {
            showDialog(
              context: context,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );

            try {
              await CategoryService.createCategory(
                      _nameTextController.text.trim(),
                      _iconTextController.text.trim())
                  .whenComplete(() => Navigator.pop(context));

              Navigator.pop(context);
              _nameTextController.clear();
              _iconTextController.clear();
              context.read<CategoryBloc>().add(FetchAllCategoryEvent());
            } catch (e) {
              showMessage(e.toString());
            }
          }
        },
        onCancel: () {
          Navigator.pop(context);
          _nameTextController.clear();
          _iconTextController.clear();
        },
        nameTextController: _nameTextController,
        iconTextcontroller: _iconTextController,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchAllCategoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Center(child: Text('Category Management')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createCategory,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
        if (state is FetchAllCategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FetchAllCategorySuccess) {
          return ListView.builder(
              itemCount: state.categoryList.length,
              itemBuilder: (context, index) {
                return CategoryTile(
                    categoryName: state.categoryList[index].name,
                    deleteFunction: (context) =>
                        deleteCategory(state.categoryList[index].id),
                    updateFunction: (context) => updateCategory(
                        state.categoryList[index].id,
                        state.categoryList[index].name,
                        state.categoryList[index].icon),
                    imageUrl: state.categoryList[index].icon);
              });
        } else if (state is FetchAllCategoryFailure) {
          return Center(child: Text(state.error));
        } else {
          return Container();
        }
      }),
    );
  }
}
