import 'package:flutter/material.dart';

import '../../screens/product_detail_screen.dart';
import '../../models/product.dart';

class ProductItem extends StatefulWidget {
  final String id;
  final String title;
  final double price;

  const ProductItem(this.id, this.title, this.price, {Key? key})
      : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Material(
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: widget.id,
          ),
          borderRadius: BorderRadius.circular(15.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('\$${widget.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                constraints: BoxConstraints(
                  minHeight: _expanded ? 60.0 : 0.0,
                  maxHeight: _expanded ? 100.0 : 0.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 4.0,
                ),
                height: 60.0,
                child: const Text('Animated'),
              ),
            ],
          ),
        ),
      ),
      margin: const EdgeInsets.all(10.0),
    );
  }
}
