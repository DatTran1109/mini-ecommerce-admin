import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final String imageUrl;
  final void Function(BuildContext)? deleteFunction;
  final void Function(BuildContext)? updateFunction;

  const CategoryTile({
    super.key,
    required this.categoryName,
    required this.deleteFunction,
    required this.updateFunction,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: updateFunction,
              icon: Icons.settings,
              backgroundColor: Colors.lightBlue.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const VerticalDivider(
                    color: Colors.black,
                    thickness: 0.1,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    categoryName,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
