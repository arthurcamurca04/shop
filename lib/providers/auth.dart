import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exceptions.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiredDate;
  Timer _logoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get userID {
    return isAuth ? _userId : null;
  }

  String get token {
    if (_token != null &&
        _expiredDate != null &&
        _expiredDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> signUp(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyB1SjayH-hn1XrTJiHgE99nRPVp0q2Gt1A';

    final response = await http.post(url,
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}));
    final responseBody = json.decode(response.body);
    if (responseBody["error"] != null) {
      throw new AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiredDate = DateTime.now().add(Duration(
        seconds: int.parse(responseBody['expiresIn']),
      ));
      _autoLogout();
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> signIn(String email, String password) async {
    const String url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB1SjayH-hn1XrTJiHgE99nRPVp0q2Gt1A";

    final response = await http.post(url,
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}));

    final responseBody = json.decode(response.body);

    if (responseBody["error"] != null) {
      throw new AuthException(responseBody["error"]["message"]);
    } else {
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiredDate = DateTime.now().add(Duration(
        seconds: int.parse(responseBody['expiresIn']),
      ));
      _autoLogout();
      notifyListeners();
    }
    return Future.value();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiredDate = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    final timeToLogout = _expiredDate.difference(DateTime.now()).inSeconds;

    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}
