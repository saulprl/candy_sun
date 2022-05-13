import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/products/quantity_field.dart';

class SellProductScreen extends StatefulWidget {
  static const routeName = '/sell-product-screen';

  const SellProductScreen({Key? key}) : super(key: key);

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  var _quantity = 1;
  var _isInit = false;
  String? _productId;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell a product'),
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
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.data!['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            '\$${product.data!['price']}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: QuantityField(
                        int.parse(
                          product.data!['quantity'],
                        ),
                        double.parse(
                          product.data!['price'],
                        ),
                        updateQuantityFn: (quantity) => _quantity = quantity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.attach_money),
                        label: const Text(
                          'Sell',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        onPressed: () async {
                          final result = await showDialog<bool>(
                              barrierDismissible: false,
                              context: context,
                              builder: (ctxt) {
                                return AlertDialog(
                                  title: Text(
                                    'Selling $_quantity ${product.data!['title']}?',
                                  ),
                                  content: const Text(
                                    'Are you sure the parameters are correct?',
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () =>
                                          Navigator.of(ctxt).pop(true),
                                    ),
                                    TextButton(
                                      child: const Text('No'),
                                      onPressed: () =>
                                          Navigator.of(ctxt).pop(false),
                                    )
                                  ],
                                );
                              });
                          if (result!) {
                            await FirebaseFirestore.instance
                                .collection('sales')
                                .add({
                              'productId': product.data!.id,
                              'productTitle': product.data!['title'],
                              'quantity': _quantity.toString(),
                              'pricePoint': product.data!['price'],
                              'sellerId':
                                  FirebaseAuth.instance.currentUser!.uid,
                              'saleDate': DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                            });

                            await FirebaseFirestore.instance
                                .doc('products/$_productId')
                                .set(
                              {
                                'quantity':
                                    (int.parse(product.data!['quantity']) -
                                            _quantity)
                                        .toString(),
                              },
                              SetOptions(
                                merge: true,
                              ),
                            );

                            ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Sold $_quantity of ${product.data!['title']}'),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            Navigator.of(ctx).pop();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
