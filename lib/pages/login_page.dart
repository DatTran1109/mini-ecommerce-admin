import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniecommerce_admin/components/my_button.dart';
import 'package:miniecommerce_admin/components/text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void signIn(BuildContext context, TextEditingController emailTextController,
      TextEditingController passwordTextController) async {
    if (emailTextController.text.trim() == '' ||
        passwordTextController.text.trim() == '') {
      showMessage(context, 'Email and password required');
      return;
    }

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(emailTextController.text.trim())
        .get();

    if (documentSnapshot.data() == null) {
      showMessage(context, 'User not found on server');
      return;
    } else {
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;

      if (userData['role'] != 'admin') {
        showMessage(context, 'You are not authorized');
        return;
      }

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailTextController.text.trim(),
            password: passwordTextController.text.trim());
      } on FirebaseAuthException catch (e) {
        showMessage(context, e.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailTextController = TextEditingController();
    final passwordTextController = TextEditingController();

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(scrollDirection: Axis.vertical, children: [
          Column(
            children: [
              const SizedBox(height: 50),
              const Icon(Icons.lock, size: 72),
              const SizedBox(height: 40),
              const Text(
                "Mini Ecommerce Admin",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              const SizedBox(height: 40),
              MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false),
              const SizedBox(height: 10),
              MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true),
              const SizedBox(height: 25),
              MyButton(
                onTap: () => signIn(
                  context,
                  emailTextController,
                  passwordTextController,
                ),
                child: const Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/forgot_password'),
                        child: const Text('Forgot password')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ]),
      ),
    ));
  }
}
