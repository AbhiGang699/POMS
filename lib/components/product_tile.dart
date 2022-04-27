import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name, description, ownerName, id;

  const ProductCard(
      {Key? key,
      required this.id,
      required this.name,
      required this.description,
      required this.ownerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(id),
            ));
          },
          child: ListTile(
            title: Text(name),
            subtitle: Text(description),
            trailing: Text(ownerName),
          ),
        ),
      ),
    );
  }
}
