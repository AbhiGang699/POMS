import 'package:flutter/material.dart';
import 'package:poms/components/product_tile.dart';

class ProductDetail extends StatefulWidget {
  final ProductCard product;
  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.product.ownerName),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.product.price + ' Eth'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.product.description),
              ),
            ],
          ),
          const SizedBox(
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_task_outlined),
                label: Text(widget.product.isOwner
                    ? 'Initiate shipping'
                    : 'Recieve from ' + widget.product.ownerName)),
          ),
        ],
      ),
    );
  }
}
