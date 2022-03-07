import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routename = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageurl_controller = TextEditingController();
  final imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _edit_product =
      Product(id: '', title: '', description: '', amount: 0.0, imageUrl: '');
  var _initValues = {
    'title': '',
    'description': '',
    'amount': '',
    'imageUrl': '',
  };

  var _isinit = true;
  @override
  void initstate() {
    imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final proId = ModalRoute.of(context)!.settings.arguments;
      if (proId != null) {
        _edit_product = Provider.of<Products>(context, listen: false)
            .findById(proId as String);
        _initValues = {
          'title': _edit_product.title,
          'description': _edit_product.description,
          'amount': _edit_product.amount.toString(),
          'imageUrl': '',
        };
        _imageurl_controller.text = _edit_product.imageUrl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageurl_controller.dispose();
    imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!imageUrlFocusNode.hasFocus) {
      if ((!_imageurl_controller.text.startsWith('http') &&
              !_imageurl_controller.text.startsWith('https')) ||
          (!_imageurl_controller.text.endsWith('.png') &&
              !_imageurl_controller.text.endsWith('.jpeg') &&
              !_imageurl_controller.text.endsWith('.jpg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveform() {
    final isval = _form.currentState!.validate();
    if (!isval) {
      return;
    }
    _form.currentState!.save();
    if (_edit_product.id != '') {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_edit_product.id, _edit_product);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_edit_product);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _edit_product.id != '' ? Text('Edit Product') : Text('Add Product'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _saveform();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _edit_product = Product(
                      title: value.toString(),
                      description: _edit_product.description,
                      amount: _edit_product.amount,
                      imageUrl: _edit_product.imageUrl,
                      id: _edit_product.id,
                      isFaviorate: _edit_product.isFaviorate);
                },
              ),
              TextFormField(
                initialValue: _initValues['amount'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a Price';
                  }
                  if (double.parse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please Enter a number greater than zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  _edit_product = Product(
                      title: _edit_product.title,
                      description: _edit_product.description,
                      amount: double.parse(value!),
                      imageUrl: _edit_product.imageUrl,
                      id: _edit_product.id,
                      isFaviorate: _edit_product.isFaviorate);
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return ' Atleast write more than 10 words';
                  }
                  return null;
                },
                onSaved: (value) {
                  _edit_product = Product(
                      title: _edit_product.title,
                      description: value.toString(),
                      amount: _edit_product.amount,
                      imageUrl: _edit_product.imageUrl,
                      id: _edit_product.id,
                      isFaviorate: _edit_product.isFaviorate);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 1,
                      color: Colors.blue,
                    )),
                    child: Container(
                      child: _imageurl_controller.text.isEmpty
                          ? Text('Enter a Url')
                          : FittedBox(
                              child: Image.network(
                                _imageurl_controller.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageurl_controller,
                      focusNode: imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveform();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a image url';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return ' Please enter a valid url';
                        }
                        if (!value.endsWith('.jpeg') &&
                            !value.endsWith('.png') &&
                            !value.endsWith('.jpg')) {
                          return ' Please enter a valid url';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _edit_product = Product(
                          title: _edit_product.title,
                          description: _edit_product.description,
                          amount: _edit_product.amount,
                          imageUrl: value.toString(),
                          id: _edit_product.id,
                          isFaviorate: _edit_product.isFaviorate,
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
