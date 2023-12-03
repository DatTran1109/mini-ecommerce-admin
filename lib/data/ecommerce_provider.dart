import 'package:flutter/material.dart';

class EcommerceProvider extends ChangeNotifier {
  String _category = '';

  String get category => _category;

  void setCategory(String category) {
    _category = category;
    notifyListeners();
  }
}
