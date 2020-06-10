import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';
import './utils/routes.dart';

import './views/cart_screen.dart';
import './views/orders_screen.dart';
import './views/product_details_screen.dart';
import './views/product_form_screen.dart';
import './views/products_screen.dart';
import './views/auth_home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => new Products(),
          update: (_, auth, previusProducts) => new Products(
            auth.token,
            auth.userID,
            previusProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => new Orders(),
          update: (_, auth, previusOrders) => Orders(
            auth.token,
            auth.userID,
            previusOrders.orders,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: AuthOrHomeScreen(),
        initialRoute: AppRoutes.AUTH_HOME,
        routes: {
          AppRoutes.PRODUCT_DETAILS: (_) => ProductDetailsScreen(),
          AppRoutes.CART_ITEMS: (_) => CartScreen(),
          AppRoutes.ORDERS: (_) => OrdersScreen(),
          AppRoutes.PRODUCTS: (_) => ProductsScreen(),
          AppRoutes.PRODUCTS_FORM: (_) => ProductFormScreen(),
        },
      ),
    );
  }
}
