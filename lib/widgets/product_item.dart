import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/utils/routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCTS_FORM, arguments: product);
              },
              color: Colors.blueAccent,
            ),
            IconButton(
              color: Theme.of(context).errorColor,
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('Excluir produto'),
                        content: Text('Deseja mesmo excluir este produto?'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text('Não'),
                          ),
                          FlatButton(
                            onPressed: () {
                              Provider.of<Products>(context, listen: false)
                                  .removeProduct(product.id);
                              Navigator.of(ctx).pop();
                            },
                            child: Text('Sim'),
                          ),
                        ],
                      );
                    },
                    context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
