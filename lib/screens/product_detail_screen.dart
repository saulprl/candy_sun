import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './edit_product_screen.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen(this.product, {Key? key}) : super(key: key);

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

  Widget _productDetails(Product prod) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textProperty('Trademark', product.trademark),
        const Divider(height: 10.0),
        _textProperty('Calories', product.calories.toStringAsFixed(2)),
        const Divider(height: 10.0),
        _textProperty('Price', product.price.toStringAsFixed(2)),
        const Divider(height: 10.0),
        _textProperty('Quantity', product.quantity.toStringAsFixed(2)),
        const Divider(height: 10.0),
        _textProperty('Cost', product.cost.toStringAsFixed(2)),
        const Divider(height: 10.0),
        _textProperty(
          'Date of purchase',
          DateFormat('yyyy-MM-dd').format(product.dateOfPurchase),
        ),
        const Divider(height: 10.0),
        _textProperty(
          'Expiration date',
          DateFormat('yyyy-MM-dd').format(product.expirationDate),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
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
                child: _productDetails(product),
              ),
            ),
          ),
          TextButton(
            child: const Text(
              'Edit product',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProductScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
