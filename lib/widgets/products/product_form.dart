import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductForm extends StatefulWidget {
  String? productId;
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

  ProductForm(
      // this.submitFn,
      // this.isLoading,
      {Key? key,
      this.productId
      // this.id,
      })
      : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  var _isInit = false;
  var _isAdd = true;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _costController = TextEditingController();
  final _quantityController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _trademarkController = TextEditingController();
  final _purchaseDateController = TextEditingController();
  final _expirationDateController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      print(widget.productId);
      if (widget.productId != null) {
        FirebaseFirestore.instance
            .doc('products/${widget.productId}')
            .get()
            .then((product) {
          _titleController.text = product['title'];
          _priceController.text = product['price'];
          _costController.text = product['cost'];
          _quantityController.text = product['quantity'];
          _caloriesController.text = product['calories'];
          _trademarkController.text = product['trademark'];
          _purchaseDateController.text = product['dateOfPurchase'];
          _expirationDateController.text = product['expirationDate'];
          _isAdd = false;
        });
      }
      _isInit = true;
    }
  }

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

  void _saveForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isAdd) {
      FirebaseFirestore.instance.collection('products').add({
        'title': _titleController.text,
        'price': _priceController.text,
        'cost': _costController.text,
        'quantity': _quantityController.text,
        'calories': _caloriesController.text,
        'dateOfPurchase': _purchaseDateController.text,
        'expirationDate': _expirationDateController.text,
        'trademark': _trademarkController.text,
      });

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product added!', textAlign: TextAlign.center),
        duration: Duration(seconds: 3),
      ));
    } else {
      FirebaseFirestore.instance.doc('products/${widget.productId}').set({
        'title': _titleController.text,
        'price': _priceController.text,
        'cost': _costController.text,
        'quantity': _quantityController.text,
        'calories': _caloriesController.text,
        'dateOfPurchase': _purchaseDateController.text,
        'expirationDate': _expirationDateController.text,
        'trademark': _trademarkController.text,
      }); //Need to swap initializers with StreamBuilders/FutureBuilders.

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product edited!', textAlign: TextAlign.center),
        duration: Duration(seconds: 3),
      ));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const ValueKey('title'),
                controller: _titleController,
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
                controller: _trademarkController,
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
                controller: _priceController,
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
                controller: _costController,
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
                controller: _quantityController,
                textInputAction: TextInputAction.done,
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
                controller: _caloriesController,
                textInputAction: TextInputAction.done,
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
                onPressed: _saveForm,
                child: const Text('Save product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
