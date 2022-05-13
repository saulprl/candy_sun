import 'package:flutter/material.dart';

class QuantityField extends StatefulWidget {
  final double price;
  final int maxQuantity;
  final Function(
    int quantity,
  ) updateQuantityFn;

  const QuantityField(
    this.maxQuantity,
    this.price, {
    Key? key,
    required this.updateQuantityFn,
  }) : super(key: key);

  @override
  State<QuantityField> createState() => _QuantityFieldState();
}

class _QuantityFieldState extends State<QuantityField> {
  var _quantity = 1;
  var _total = 0.0;

  @override
  void initState() {
    super.initState();
    _total = _quantity * widget.price;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Container(
            //   width: 32.0,
            //   height: 32.0,
            //   margin: const EdgeInsets.symmetric(horizontal: 16.0),
            // child:
            ElevatedButton(
              child: const Icon(Icons.remove),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  _quantity == 1 ? _quantity : _quantity--;
                  _total = _quantity * widget.price;
                });
                widget.updateQuantityFn(_quantity);
              },
            ),
            // ),
            Text(
              _quantity.toString(),
              style: TextStyle(
                color:
                    _quantity == widget.maxQuantity ? Colors.red : Colors.black,
                fontSize: 16.0,
              ),
            ),
            ElevatedButton(
              child: const Icon(Icons.add),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  _quantity == widget.maxQuantity ? _quantity : _quantity++;
                  _total = _quantity * widget.price;
                });
                widget.updateQuantityFn(_quantity);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Total: ',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Text(
                '\$${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
