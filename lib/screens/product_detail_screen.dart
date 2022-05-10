import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import './edit_product_screen.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _productId;
  var _isInit = false;
  Map<String, String> _initValues = {
    'id': '',
    'title': '',
    'price': '',
    'cost': '',
    'quantity': '',
    'trademark': '',
    'calories': '',
    'dateOfPurchase': '2000-01-01',
    'expirationDate': '2000-01-01',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        _productId = ModalRoute.of(context)!.settings.arguments as String;
        FirebaseFirestore.instance
            .doc('products/$_productId')
            .get()
            .then((value) {
          setState(() {
            _initValues = {
              'id': value.id,
              'title': value['title'],
              'price': value['price'],
              'cost': value['cost'],
              'calories': value['calories'],
              'quantity': value['quantity'],
              'trademark': value['trademark'],
              'dateOfPurchase': value['dateOfPurchase'],
              'expirationDate': value['expirationDate'],
            };
          });
        });
      }
      _isInit = true;
    }
  }

  Widget _textProperty(String propertyName, String value) {
    Widget textWidget;

    if (propertyName == 'Price') {
      textWidget = Text(
        '$propertyName: \$$value',
        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      );
    } else if (propertyName == 'Cost') {
      textWidget = Text(
        '$propertyName: \$$value',
        style: const TextStyle(fontSize: 20.0, color: Colors.grey),
      );
    } else if (propertyName == 'Calories') {
      textWidget = Text(
        '$propertyName: $value kcal.',
        style: const TextStyle(fontSize: 20.0),
      );
    } else {
      textWidget = Text(
        '$propertyName: $value',
        style: const TextStyle(fontSize: 20.0),
      );
    }
    return textWidget;
  }

  Widget _productDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textProperty('Trademark', _initValues['trademark']!),
        const Divider(height: 10.0),
        _textProperty('Calories', _initValues['calories']!),
        const Divider(height: 10.0),
        _textProperty('Price', _initValues['price']!),
        const Divider(height: 10.0),
        _textProperty('Quantity', _initValues['quantity']!),
        const Divider(height: 10.0),
        _textProperty('Cost', _initValues['cost']!),
        const Divider(height: 10.0),
        _textProperty(
          'Date of purchase',
          DateFormat('yyyy-MM-dd')
              .parse(_initValues['dateOfPurchase']!)
              .toString()
              .split(' ')
              .first,
        ),
        const Divider(height: 10.0),
        _textProperty(
          'Expiration date',
          DateFormat('yyyy-MM-dd')
              .parse(_initValues['expirationDate']!)
              .toString()
              .split(' ')
              .first,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_initValues['title']!),
      ),
      body: Column(
        children: [
          Card(
            elevation: 2,
            margin: const EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 250,
                child: _productDetails(),
              ),
            ),
          ),
          TextButton(
            child: const Text(
              'Edit product',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: _productId,
              );
            },
          ),
        ],
      ),
    );
  }
}
