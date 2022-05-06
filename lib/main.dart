import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialization,
      builder: (ctx, appSnapshot) {
        return MaterialApp(
          title: 'Candy Sun',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.pink,
              secondary: Colors.deepPurple[500],
            ),
          ),
          home: ProductsOverviewScreen(),
        );
      },
    );
  }
}
