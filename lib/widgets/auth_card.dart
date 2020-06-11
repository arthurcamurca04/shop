import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exceptions.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { SignUp, LogIn }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _formState = GlobalKey();
  bool _isloading = false;
  bool isPasswordVisible = false;
  AuthMode _authMode = AuthMode.LogIn;

  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Ocorreu um Erro!'),
              content: Text(msg),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Fechar'),
                ),
              ],
            ));
  }

  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formState.currentState.validate()) {
      return;
    }

    setState(() {
      _isloading = true;
    });

    _formState.currentState.save();
    Auth authProvider = Provider.of<Auth>(context, listen: false);

    try {
      if (_authMode == AuthMode.LogIn) {
        //realizar login
        await authProvider.signIn(_authData["email"], _authData["password"]);
      } else {
        //registrar usuário
        await authProvider.signUp(_authData["email"], _authData["password"]);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (e) {
      _showErrorDialog("Erro inesperado");
    }

    setState(() {
      _isloading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.LogIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.LogIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: deviceSize.width * 0.9,
      height: deviceSize.height * 0.36,
      child: Form(
        key: _formState,
        child: ListView(
          
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Preencha o campo corretamente!';
                }
                return null;
              },
              onSaved: (value) => _authData["email"] = value,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: !isPasswordVisible,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: isPasswordVisible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                labelText: 'Senha',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Preencha o campo corretamente!';
                } else if (value.length < 5 || value.length > 15) {
                  return 'Senha deve conter entre 5 e 15 caracteres!';
                } else {
                  return null;
                }
              },
              onSaved: (value) => _authData["password"] = value,
            ),
            SizedBox(height: 3),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).primaryTextTheme.button.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: _submit,
              child: _isloading
                  ? FittedBox(fit: BoxFit.contain, child: CircularProgressIndicator())
                  : Text(_authMode == AuthMode.LogIn ? 'Entrar' : 'Registrar'),
            ),
            FlatButton(
              onPressed: _switchAuthMode,
              textColor: Theme.of(context).accentColor,
              child: Text(
                _authMode == AuthMode.LogIn
                    ? 'Ainda não registrado? Registre-se'
                    : 'Fazer login',
              ),
            )
          ],
        ),
      ),
    );
  }
}
