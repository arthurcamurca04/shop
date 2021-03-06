import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/utils/routes.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/product_item.dart';

class ProductsScreen extends StatelessWidget {

  Future<void> _refreshProducts(BuildContext context){
    return Provider.of<Products>(context, listen: false).loadProducts();

  }
  @override
  Widget build(BuildContext context) {

    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(AppRoutes.PRODUCTS_FORM);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
              child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: products.itemCount,
            itemBuilder: (_, index){
              return Column(
                children: <Widget>[
                  ProductItem(product: products.items[index],),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
