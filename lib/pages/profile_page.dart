import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniecommerce_admin/components/password_dialog.dart';
import 'package:miniecommerce_admin/components/profile_detail.dart';
import 'package:miniecommerce_admin/components/profile_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    String userEmail = currentUser!.email as String;
    final userCollection = FirebaseFirestore.instance.collection('Users');
    final controller = TextEditingController();
    final oldPasswordcontroller = TextEditingController();
    final newPasswordcontroller = TextEditingController();
    final confirmPasswordcontroller = TextEditingController();
    late Timer timer;

    void showMessage(String message) {
      showDialog(
        context: context,
        builder: (context) {
          timer =
              Timer(const Duration(seconds: 2), () => Navigator.pop(context));

          return AlertDialog(
            content: Text(
              message,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w400, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        },
      ).whenComplete(() {
        if (timer.isActive) {
          timer.cancel();
        }
      });
    }

    Future saveProfileDetail(String field) async {
      if (controller.text.trim().isNotEmpty) {
        await userCollection
            .doc(currentUser.email)
            .update({field: controller.text.trim()}).whenComplete(
                () => Navigator.pop(context));

        controller.clear();
      } else {
        controller.clear();
        showMessage('Field is empty, please enter something!');
      }
    }

    Future savePassword(String email) async {
      if (oldPasswordcontroller.text.trim().isEmpty ||
          newPasswordcontroller.text.trim().isEmpty ||
          confirmPasswordcontroller.text.trim().isEmpty) {
        showMessage('All fields are required!');
        return;
      } else if (newPasswordcontroller.text.trim() !=
          confirmPasswordcontroller.text.trim()) {
        showMessage('Password and confirm password are different!');
        return;
      } else {
        showDialog(
          context: context,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        try {
          final cred = EmailAuthProvider.credential(
            email: email,
            password: oldPasswordcontroller.text.trim(),
          );

          await currentUser
              .reauthenticateWithCredential(cred)
              .then((value) =>
                  currentUser.updatePassword(newPasswordcontroller.text.trim()))
              .whenComplete(() => Navigator.pop(context));

          Navigator.pop(context);
          oldPasswordcontroller.clear();
          newPasswordcontroller.clear();
          confirmPasswordcontroller.clear();
          showMessage('Change password successfully');
        } on FirebaseAuthException catch (e) {
          oldPasswordcontroller.clear();
          newPasswordcontroller.clear();
          confirmPasswordcontroller.clear();
          showMessage(e.code);
        }
      }
    }

    void editField(String field) {
      showDialog(
          context: context,
          builder: (context) => ProfileDialog(
              onSave: () => saveProfileDetail(field),
              onCancel: () {
                Navigator.pop(context);
                controller.clear();
              },
              controller: controller,
              field: field));
    }

    void changePassword(String field, String email) {
      showDialog(
          context: context,
          builder: (context) => PasswordDialog(
              onSave: () => savePassword(email),
              onCancel: () {
                Navigator.pop(context);
                oldPasswordcontroller.clear();
                newPasswordcontroller.clear();
                confirmPasswordcontroller.clear();
              },
              oldPasswordcontroller: oldPasswordcontroller,
              newPasswordcontroller: newPasswordcontroller,
              confirmPasswordcontroller: confirmPasswordcontroller,
              field: field));
    }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data();

              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Detail',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  ProfileDetail(
                    text: userData!['username'],
                    sectionName: 'username',
                    onPressed: () {
                      controller.text = userData['username'];
                      editField('username');
                    },
                  ),
                  ProfileDetail(
                    text: userData['address'],
                    sectionName: 'address',
                    onPressed: () {
                      controller.text = userData['address'];
                      editField('address');
                    },
                  ),
                  ProfileDetail(
                    text: '**********',
                    sectionName: 'password',
                    onPressed: () => changePassword('password', userEmail),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 140),
                    child: MaterialButton(
                      onPressed: signOut,
                      padding: const EdgeInsets.all(12),
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Text('Error ${snapshot.hasError}');
            }
          },
        ));
  }
}
