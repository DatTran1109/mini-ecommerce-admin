import 'package:flutter/material.dart';
import 'package:miniecommerce_admin/pages/category_page.dart';
// import 'package:miniecommerce_admin/pages/order_page.dart';
import 'package:miniecommerce_admin/pages/product_page.dart';
import 'package:miniecommerce_admin/pages/profile_page.dart';
// import 'package:miniecommerce_admin/pages/user_page.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const CategoryPage(),
    const ProductPage(),
    // const OrderPage(),
    // const UserPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.grey.shade500,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopify),
            label: 'Product',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_cart),
          //   label: 'Order',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person_add),
          //   label: 'User',
          // ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
