import 'dart:convert';

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
  Map<String, dynamic> _initValues = {
    'id': '',
    'title': '',
    'price': '',
    'cost': '',
    'quantity': '',
    'trademark': '',
    'calories': '',
    'dateOfPurchase': DateTime.now(),
    'expirationDate': DateTime.now(),
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        _productId = ModalRoute.of(context)!.settings.arguments as String;
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
      body: FutureBuilder(
        future: FirebaseFirestore.instance.doc('products/$_productId').get(),
        builder: (ctx,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> product) {
          if (product.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(ctx).colorScheme.secondary),
            );
          }
          _initValues = product.data!.data()!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
                  Navigator.of(context)
                      .pushNamed(
                    EditProductScreen.routeName,
                    arguments: _productId,
                  )
                      .then((value) {
                    if (value.toString() == 'true') {
                      setState(() {});
                    }
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
