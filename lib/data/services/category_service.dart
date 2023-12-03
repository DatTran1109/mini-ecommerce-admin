import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miniecommerce_admin/data/models/category_model.dart';

class CategoryService {
  static Future<List<CategoryModel>> fetchAllCategory() async {
    final uri =
        Uri.parse('https://bewildered-toad-veil.cyclic.app/api/v1/category');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final dataList = jsonDecode(response.body) as List<dynamic>;

      List<CategoryModel> categoryList = dataList.map((item) {
        return CategoryModel.fromJson(item);
      }).toList();

      return categoryList;
    } else {
      throw Exception("Failed to load category");
    }
  }

  static Future<void> createCategory(String name, String icon) async {
    final uri =
        Uri.parse('https://bewildered-toad-veil.cyclic.app/api/v1/category');

    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'name': name, 'icon': icon}));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to create category");
    }
  }

  static Future<void> deleteCategory(String id) async {
    final uri = Uri.parse(
        'https://bewildered-toad-veil.cyclic.app/api/v1/category/$id');

    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to delete category");
    }
  }

  static Future<void> updateCategory(
      String id, String name, String icon) async {
    final uri = Uri.parse(
        'https://bewildered-toad-veil.cyclic.app/api/v1/category/$id');

    final response = await http.put(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"name": name, "icon": icon}));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to update category");
    }
  }
}
