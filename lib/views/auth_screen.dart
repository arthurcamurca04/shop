import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, .5),
                  Color.fromRGBO(255, 188, 117, .9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 50),
                transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.deepOrange.shade900,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2)),
                    ]),
                child: Text(
                  'Minha Loja',
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Anton',
                      color:
                          Theme.of(context).accentTextTheme.headline6.color),
                ),
              ),
              AuthCard(),
            ],
          ),
        ],
      ),
    );
  }
}
