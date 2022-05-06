import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/product_item.dart';
import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static final routeName = '/';
  final List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Skittles',
      price: 2.49,
      cost: 1.99,
      calories: 150.0,
      quantity: 25,
      dateOfPurchase: DateTime(2022, 5, 2),
      expirationDate: DateTime(2023, 12, 15),
      trademark: 'Placeholder',
    ),
    Product(
      id: 'p2',
      title: 'Prod 2',
      price: 2.49,
      cost: 1.99,
      calories: 150.0,
      quantity: 25,
      dateOfPurchase: DateTime(2022, 5, 2),
      expirationDate: DateTime(2023, 12, 15),
      trademark: 'Placeholder',
    ),
    Product(
      id: 'p3',
      title: 'Prod 3',
      price: 2.49,
      cost: 1.99,
      calories: 150.0,
      quantity: 25,
      dateOfPurchase: DateTime(2022, 5, 2),
      expirationDate: DateTime(2023, 12, 15),
      trademark: 'Placeholder',
    ),
    Product(
      id: 'p4',
      title: 'Prod 4',
      price: 2.49,
      cost: 1.99,
      calories: 150.0,
      quantity: 25,
      dateOfPurchase: DateTime(2022, 5, 2),
      expirationDate: DateTime(2023, 12, 15),
      trademark: 'Placeholder',
    ),
    Product(
      id: 'p5',
      title: 'Prod 5',
      price: 2.49,
      cost: 1.99,
      calories: 150.0,
      quantity: 25,
      dateOfPurchase: DateTime(2022, 5, 2),
      expirationDate: DateTime(2023, 12, 15),
      trademark: 'Placeholder',
    ),
  ];

  ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> productsSnapshot) {
          if (productsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = productsSnapshot.data!.docs;
          return ListView.builder(
            itemBuilder: (ctx, index) => ProductItem(
              documents[index]['title'],
              double.parse(documents[index]['price']),
            ),
            itemCount: documents.length,
          );
        },
      ),
    );
  }
}
