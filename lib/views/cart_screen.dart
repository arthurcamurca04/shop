import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: Text('Carrinho')),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(cartItems);
                      cart.clear();
                    },
                    child: Text('COMPRAR'),
                    textColor: Theme.of(context).primaryColor,
                  ),
                  
                ],
              ),
            ),
          ),
          SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (_, index){
                        return(
                          CartItemWidget(cartItem: cartItems[index],)
                        );
                      },
                      itemCount: cart.itemsCount,
                      separatorBuilder: (_, __){
                        return Divider();
                      },
                    ),
                  ),
        ],
      ),
    );
  }
}
