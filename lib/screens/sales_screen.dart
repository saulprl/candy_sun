import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalesScreen extends StatefulWidget {
  static const routeName = '/sales-screen';

  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  var _quantity = 1;
  var _isInit = false;
  final _quantityController = TextEditingController(text: '1');
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
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.data!['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        product.data!['price'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          child: const Icon(Icons.remove),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(ctx).colorScheme.secondary),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _quantityController,
                          readOnly: true,
                        ),
                        flex: 1,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => setState(() {
                          _quantity++;
                        }),
                        icon: const Icon(Icons.add),
                        label: const Text(''),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
