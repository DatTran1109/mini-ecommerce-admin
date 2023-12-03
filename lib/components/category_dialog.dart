import 'package:flutter/material.dart';

class CategoryDialog extends StatelessWidget {
  final String title;
  final Function()? onSave;
  final Function()? onCancel;
  final TextEditingController nameTextController;
  final TextEditingController iconTextcontroller;
  const CategoryDialog(
      {super.key,
      required this.onSave,
      required this.onCancel,
      required this.nameTextController,
      required this.iconTextcontroller,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(title)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: nameTextController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter category name',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12)),
              fillColor: Theme.of(context).colorScheme.primary,
              filled: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: iconTextcontroller,
            decoration: InputDecoration(
              hintText: 'Enter image url',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12)),
              fillColor: Theme.of(context).colorScheme.primary,
              filled: true,
            ),
          ),
        ],
      ),
      actions: [
        MaterialButton(onPressed: onSave, child: const Text('Okay')),
        MaterialButton(onPressed: onCancel, child: const Text('Cancel')),
      ],
    );
  }
}
