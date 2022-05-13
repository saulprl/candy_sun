import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/sales/sale_item.dart';

class SalesScreen extends StatelessWidget {
  static const routeName = '/sales-screen';

  const SalesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('sales').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> salesSnapshot) {
          if (salesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(ctx).colorScheme.secondary,
              ),
            );
          }
          final documents = salesSnapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctxt, index) {
              return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .doc('users/${documents[index]['sellerId']}')
                      .get(),
                  builder: (_,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          seller) {
                    if (seller.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(ctxt).colorScheme.secondary),
                      );
                    }
                    return SaleItem(
                      productTitle: documents[index]['productTitle'],
                      price: documents[index]['pricePoint'],
                      quantity: documents[index]['quantity'],
                      total: (double.parse(documents[index]['pricePoint']) *
                              int.parse(documents[index]['quantity']))
                          .toString(),
                      saleDate: documents[index]['saleDate'],
                      sellerEmail: seller.data!['email'],
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
