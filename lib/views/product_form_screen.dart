import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImage() {
    setState(() {});
  }

  void _saveForm() async{
    bool isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final product = Product(
      id: _formData['id'],
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
    );

    setState(() {
      isValid = true;
    });

    final products = Provider.of<Products>(context, listen: false);

    try {
      if (_formData['id'] == null) {
        await products.addProduct(product).then((_) {
          setState(() {
            isValid = false;
          });
        });
      } else {
        await products.updateProduct(product);
        setState(() {
          isValid = false;
        });
      }
      Navigator.of(context).pop();
    } catch (e) {
      await showDialog<Null>(
        context: context,
  
        builder: (ctx) => AlertDialog(
          title: Text('Erro inesperado'),
          content: Text('Ocorreu um erro ao tentar adicionar um produto.'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(ctx).pop();
              },
              child: Text('Fechar'),
            )
          ],
        ),
      );
    }finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário produto'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _formData['title'],
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Ops! Informe o título';
                        }

                        if (value.trim().length < 3) {
                          return 'Informe um título com no mínimo 3 letras';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      decoration: InputDecoration(
                        labelText: 'Título',
                      ),
                      onSaved: (value) => _formData['title'] = value,
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Informe o preço';
                        }

                        if (double.parse(value) < 0) {
                          return 'Informe um valor maior que zero';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      focusNode: _priceFocusNode,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Preço',
                      ),
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Dê uma descrição';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['description'] = value,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Informe uma URL';
                              }
                              return null;
                            },
                            onSaved: (value) => _formData['imageUrl'] = value,
                            focusNode: _imageUrlFocusNode,
                            decoration:
                                InputDecoration(labelText: 'URL da Imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? Text('Informe a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
