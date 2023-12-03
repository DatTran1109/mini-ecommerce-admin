import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miniecommerce_admin/data/models/product_model.dart';

class ProductService {
  static Future<List<ProductModel>> fetchAllProduct({
    String page = '1',
    String limit = '20',
    String search = '',
    String sort = '',
    String category = 'all',
  }) async {
    final url = Uri.parse(
        'https://bewildered-toad-veil.cyclic.app/api/v1/product?search=$search&category=$category&sort=$sort&page=$page&limit=$limit');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // final dataMap = json.decode(response.body) as Map<String, dynamic>;
      // final dataList = dataMap['products'] as List<dynamic>;
      final dataList = jsonDecode(response.body) as List<dynamic>;

      List<ProductModel> productList = dataList.map((item) {
        return ProductModel.fromJson(item);
      }).toList();

      return productList;
    } else {
      throw Exception("Failed to load products");
    }
  }

  static Future<void> createProduct(Map<String, dynamic> body) async {
    final uri =
        Uri.parse('https://bewildered-toad-veil.cyclic.app/api/v1/product');

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to create category");
    }
  }

  static Future<void> deleteProduct(String id) async {
    final uri =
        Uri.parse('https://bewildered-toad-veil.cyclic.app/api/v1/product/$id');

    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to delete category");
    }
  }

  static Future<void> updateProduct(
      String id, Map<String, dynamic> body) async {
    final uri =
        Uri.parse('https://bewildered-toad-veil.cyclic.app/api/v1/product/$id');

    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to update category");
    }
  }
}
