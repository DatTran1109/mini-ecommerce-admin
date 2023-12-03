import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniecommerce_admin/auth/auth.dart';
import 'package:miniecommerce_admin/bloc/category_bloc.dart';
import 'package:miniecommerce_admin/bloc/product_bloc.dart';
import 'package:miniecommerce_admin/data/ecommerce_provider.dart';
import 'package:miniecommerce_admin/firebase_options.dart';
import 'package:miniecommerce_admin/pages/forgot_password.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<CategoryBloc>(
        create: (context) => CategoryBloc(),
      ),
      BlocProvider<ProductBloc>(
        create: (context) => ProductBloc(),
      ),
    ],
    child: ChangeNotifierProvider(
      create: (context) => EcommerceProvider(),
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      routes: {
        '/forgot_password': (context) => const ForgotPasswordPage(),
      },
      home: const Auth(),
    );
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    centerTitle: true,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade100,
    secondary: Colors.white,
    inversePrimary: Colors.grey.shade500,
  ),
);
