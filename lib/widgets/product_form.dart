import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductForm extends StatefulWidget {
  // final void Function(
  //   String title,
  //   double price,
  //   double cost,
  //   DateTime dateOfPurchase,
  //   int quantity,
  //   double calories,
  //   String trademark,
  //   DateTime expirationDate,
  // ) submitFn;
  // final bool isLoading;
  // final String? id;

  const ProductForm(
      // this.submitFn,
      // this.isLoading,
      {
    Key? key,
    // this.id,
  }) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _purchaseDateController = TextEditingController();
  final _expirationDateController = TextEditingController();

  void _showDatePicker(TextEditingController controller) {
    final DateTime firstDate;
    final DateTime lastDate;
    final DateTime initialDate;
    if (controller.text.isEmpty) {
      initialDate = DateTime.now();
    } else {
      initialDate = DateFormat('yyyy-MM-dd').parse(controller.text);
    }

    if (controller == _purchaseDateController) {
      firstDate = DateTime.now().subtract(const Duration(days: 730));
      lastDate = DateTime.now();
    } else {
      firstDate = DateTime.now();
      lastDate = DateTime.now().add(const Duration(days: 730));
    }

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ).then((dateChosen) {
      if (dateChosen == null) {
        return;
      }

      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(dateChosen);
      });
    });
  }

  void _saveForm() {}

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const ValueKey('title'),
                autocorrect: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Title can\'t be empty!';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              TextFormField(
                key: const ValueKey('trademark'),
                autocorrect: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Trademark',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Trademark can\'t be empty!';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              TextFormField(
                key: const ValueKey('price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'The price can\'t be empty!';
                  }
                  if (double.tryParse(value)! < 0.0) {
                    return 'The price can\'t be negative!';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const ValueKey('cost'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cost',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'The cost can\'t be empty!';
                  }
                  if (double.tryParse(value)! < 0.0) {
                    return 'The cost can\'t be negative!';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const ValueKey('quantity'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'The quantity can\'t be empty!';
                  }
                  if (int.tryParse(value)! < 0) {
                    return 'The quantity can\'t be negative!';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const ValueKey('purchaseDate'),
                controller: _purchaseDateController,
                decoration: const InputDecoration(
                  labelText: 'Purchase Date',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Date of purchase can\'t be empty!';
                  }
                  if (DateFormat('yyyy-MM-dd')
                      .parse(value)
                      .isAfter(DateTime.now())) {
                    return 'Date of purchase hasn\'t happened yet!';
                  }
                  return null;
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _showDatePicker(_purchaseDateController);
                },
              ),
              TextFormField(
                key: const ValueKey('expirationDate'),
                controller: _expirationDateController,
                decoration: const InputDecoration(
                  labelText: 'Expiration Date',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Expiration date can\'t be empty!';
                  }
                  if (DateFormat('yyyy-MM-dd')
                      .parse(value)
                      .isBefore(DateTime.now())) {
                    return 'Expiration date has already happened!';
                  }
                  return null;
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _showDatePicker(_expirationDateController);
                },
              ),
              TextFormField(
                key: const ValueKey('calories'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Calories can\'t be empty!';
                  }
                  if (double.tryParse(value)! < 0.0) {
                    return 'Calories can\'t be negative!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
