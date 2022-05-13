import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SaleItem extends StatefulWidget {
  final String productTitle;
  final String quantity;
  final String price;
  final String total;
  final String sellerEmail;
  final String saleDate;

  const SaleItem({
    Key? key,
    required this.productTitle,
    required this.quantity,
    required this.price,
    required this.total,
    required this.sellerEmail,
    required this.saleDate,
  }) : super(key: key);

  @override
  State<SaleItem> createState() => _SaleItemState();
}

class _SaleItemState extends State<SaleItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: FittedBox(
                  child: Text('\$${widget.total}'),
                ),
              ),
            ),
            title: Text(
              widget.productTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('\$${widget.price}'),
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
              minHeight: _expanded ? 40.0 : 0.0,
              maxHeight: _expanded ? 80.0 : 0.0,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 4.0,
            ),
            height: 60.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Quantity: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.quantity),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Date: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.saleDate),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Text(
                        'Sold by: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(widget.sellerEmail),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
