import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/products/product_item.dart';
import '../widgets/global/main_drawer.dart';
import './edit_product_screen.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const routeName = '/';
  // final List<Product> _products = [
  //   Product(
  //     id: 'p1',
  //     title: 'Skittles',
  //     price: 2.49,
  //     cost: 1.99,
  //     calories: 150.0,
  //     quantity: 25,
  //     dateOfPurchase: DateTime(2022, 5, 2),
  //     expirationDate: DateTime(2023, 12, 15),
  //     trademark: 'Placeholder',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Prod 2',
  //     price: 2.49,
  //     cost: 1.99,
  //     calories: 150.0,
  //     quantity: 25,
  //     dateOfPurchase: DateTime(2022, 5, 2),
  //     expirationDate: DateTime(2023, 12, 15),
  //     trademark: 'Placeholder',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Prod 3',
  //     price: 2.49,
  //     cost: 1.99,
  //     calories: 150.0,
  //     quantity: 25,
  //     dateOfPurchase: DateTime(2022, 5, 2),
  //     expirationDate: DateTime(2023, 12, 15),
  //     trademark: 'Placeholder',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'Prod 4',
  //     price: 2.49,
  //     cost: 1.99,
  //     calories: 150.0,
  //     quantity: 25,
  //     dateOfPurchase: DateTime(2022, 5, 2),
  //     expirationDate: DateTime(2023, 12, 15),
  //     trademark: 'Placeholder',
  //   ),
  //   Product(
  //     id: 'p5',
  //     title: 'Prod 5',
  //     price: 2.49,
  //     cost: 1.99,
  //     calories: 150.0,
  //     quantity: 25,
  //     dateOfPurchase: DateTime(2022, 5, 2),
  //     expirationDate: DateTime(2023, 12, 15),
  //     trademark: 'Placeholder',
  //   ),
  // ];

  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('title')
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> productsSnapshot) {
          if (productsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = productsSnapshot.data!.docs;
          return ListView.builder(
            itemBuilder: (ctx, index) => ProductItem(
              documents[index].id,
              documents[index]['title'],
              documents[index]['price'],
              documents[index]['quantity'],
              documents[index]['expirationDate'],
              scaffoldKey: _scaffoldKey,
              key: ValueKey(documents[index].id),
            ),
            itemCount: documents.length,
          );
        },
      ),
    );
  }
}
