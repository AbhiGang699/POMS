import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name, description, ownerName, id;
  final bool isOwner;

  const ProductCard(
      {Key? key,
      required this.id,
      required this.name,
      required this.description,
      required this.ownerName,
      required this.isOwner})
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(name),
                subtitle: Text(description),
                trailing: Text(ownerName),
              ),
              isOwner
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('Initiate Shipping'),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Initiate'),
                            ));
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('Request Product'),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Request'),
                            ));
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
