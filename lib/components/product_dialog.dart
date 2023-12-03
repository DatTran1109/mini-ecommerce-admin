import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniecommerce_admin/bloc/category_bloc.dart';
import 'package:miniecommerce_admin/data/ecommerce_provider.dart';

class ProductDialog extends StatefulWidget {
  final String title;
  final String? dropdownValue;
  final Function()? onSave;
  final Function()? onCancel;
  final TextEditingController nameTextController;
  final TextEditingController descriptTextController;
  final TextEditingController priceTextController;
  final TextEditingController sizeMTextController;
  final TextEditingController sizeLTextController;
  final TextEditingController sizeSTextController;
  final TextEditingController sizeXLTextController;
  final TextEditingController image1TextController;
  final TextEditingController image2TextController;
  final TextEditingController image3TextController;
  final TextEditingController image4TextController;
  const ProductDialog(
      {super.key,
      required this.onSave,
      required this.onCancel,
      required this.nameTextController,
      required this.title,
      required this.descriptTextController,
      required this.priceTextController,
      required this.sizeMTextController,
      required this.sizeLTextController,
      required this.sizeSTextController,
      required this.sizeXLTextController,
      required this.image1TextController,
      required this.image2TextController,
      required this.image3TextController,
      required this.image4TextController,
      this.dropdownValue});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchAllCategoryEvent());
    _dropdownValue = widget.dropdownValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Center(child: Text(widget.title)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: widget.nameTextController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter product name',
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
            controller: widget.descriptTextController,
            decoration: InputDecoration(
              hintText: 'Enter product description',
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
            controller: widget.priceTextController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter product price',
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
          Row(
            children: [
              const Text('Category:', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 10),
              BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                if (state is FetchAllCategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FetchAllCategorySuccess) {
                  return DropdownButton(
                    dropdownColor: Theme.of(context).colorScheme.primary,
                    iconEnabledColor: Colors.deepPurpleAccent,
                    elevation: 0,
                    items: state.categoryList.map((item) {
                      return DropdownMenuItem(
                        value: item.name.toLowerCase(),
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    value: _dropdownValue,
                    onChanged: (String? value) {
                      if (value == '') {
                        setState(() {
                          _dropdownValue = null;
                        });
                        return;
                      }

                      if (value is String) {
                        setState(() {
                          _dropdownValue = value;
                        });
                        context.read<EcommerceProvider>().setCategory(value);
                      }
                    },
                  );
                } else if (state is FetchAllCategoryFailure) {
                  return Center(child: Text(state.error));
                } else {
                  return Container();
                }
              }),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                  width: 100,
                  child:
                      Text('Size M quantity', style: TextStyle(fontSize: 14))),
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: widget.sizeMTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter size M product quantity',
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
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                  width: 100,
                  child:
                      Text('Size L quantity', style: TextStyle(fontSize: 14))),
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: widget.sizeLTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                  width: 100,
                  child:
                      Text('Size S quantity', style: TextStyle(fontSize: 14))),
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: widget.sizeSTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                  width: 100,
                  child:
                      Text('Size XL quantity', style: TextStyle(fontSize: 14))),
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: widget.sizeXLTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: widget.image1TextController,
            decoration: InputDecoration(
              hintText: 'Enter product image 1',
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
            controller: widget.image2TextController,
            decoration: InputDecoration(
              hintText: 'Enter product image 2',
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
            controller: widget.image3TextController,
            decoration: InputDecoration(
              hintText: 'Enter product image 3',
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
            controller: widget.image4TextController,
            decoration: InputDecoration(
              hintText: 'Enter product image 4',
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
        MaterialButton(onPressed: widget.onSave, child: const Text('Okay')),
        MaterialButton(onPressed: widget.onCancel, child: const Text('Cancel')),
      ],
    );
  }
}
