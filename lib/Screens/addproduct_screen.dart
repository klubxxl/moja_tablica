// ignore_for_file: file_names, curly_braces_in_flow_control_structures, non_constant_identifier_names, unused_field, prefer_final_fields, unused_local_variable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/product_model.dart';
import 'package:mojatablica/Providers/products_provider.dart';
import 'package:provider/provider.dart';

class SAddProduct extends StatefulWidget {
  static const String routName = 'SAddProduct';

  const SAddProduct({Key? key}) : super(key: key);

  @override
  _SAddProductState createState() => _SAddProductState();
}

class _SAddProductState extends State<SAddProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _froms = GlobalKey<FormState>();
  bool _isLoading = false;

  Product _newProd =
      Product(id: 'null', description: '', title: '', imageUrl: '', price: -1);

  bool _isInit = false;
  var _InitStates = {
    'title': '',
    'description': '',
    'price': '',
  };

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImegeUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit == false) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;
        _newProd =
            Provider.of<Products>(context, listen: false).selectById(productId);
        _InitStates = {
          'title': _newProd.title,
          'description': _newProd.description,
          'price': _newProd.price.toString(),
        };
        _imageUrlController.text = _newProd.imageUrl;
        print(_newProd.title + " " + _newProd.id);
      }
    }
    super.didChangeDependencies();
  }

  void _updateImegeUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.startsWith('http')) {
        setState(() {});
      }
    }
  }

  Future<void> _saveFomrsData() async {
    final isValidate = _froms.currentState!.validate();
    if (!isValidate) return;

    _froms.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_newProd.id == 'null') {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_newProd);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(error.toString()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"))
            ],
          ),
        );
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateById(_newProd.id, _newProd);
      } catch (error) {
        rethrow;
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add new product"),
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
                onPressed: () {
                  _saveFomrsData();
                },
                icon: const Icon(Icons.save))
          ],
        ),
        body: Form(
            key: _froms,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: "title"),
                          initialValue: _InitStates['title'],
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter data.";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(_priceFocusNode),
                          onSaved: (newValue) {
                            _newProd = Product(
                                id: _newProd.id,
                                description: _newProd.description,
                                title: newValue!,
                                imageUrl: _newProd.imageUrl,
                                price: _newProd.price,
                                isFavorite: _newProd.isFavorite);
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "price"),
                          initialValue: _InitStates['price'],
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter data.";
                            } else if (double.tryParse(value) == null) {
                              return "Please enter a number";
                            } else if (double.parse(value) < 0) {
                              return "Please enter positive number";
                            } else {
                              return null;
                            }
                          },
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode),
                          onSaved: (newValue) {
                            _newProd = Product(
                                id: _newProd.id,
                                description: _newProd.description,
                                title: _newProd.title,
                                imageUrl: _newProd.imageUrl,
                                price: double.parse(newValue!),
                                isFavorite: _newProd.isFavorite);
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "description"),
                          initialValue: _InitStates['description'],
                          maxLines: 3,
                          textInputAction: TextInputAction.newline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter data.";
                            } else if (value.length < 10) {
                              return "Please enter longer description.";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            _newProd = Product(
                                id: _newProd.id,
                                description: newValue!,
                                title: _newProd.title,
                                imageUrl: _newProd.imageUrl,
                                price: _newProd.price,
                                isFavorite: _newProd.isFavorite);
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.grey)),
                              child: _imageUrlController.text.isEmpty
                                  ? const Center(
                                      child: Text("Entry the Url"),
                                    )
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 140,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "image Url"),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                focusNode: _imageUrlFocusNode,
                                controller: _imageUrlController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter data.";
                                  } else if (!value.startsWith('http')) {
                                    return 'Please enter valid adress';
                                  } else {
                                    return null;
                                  }
                                },
                                onFieldSubmitted: (_) {
                                  _saveFomrsData();
                                },
                                onSaved: (newValue) {
                                  _newProd = Product(
                                      id: _newProd.id,
                                      description: _newProd.description,
                                      title: _newProd.title,
                                      imageUrl: newValue!,
                                      price: _newProd.price,
                                      isFavorite: _newProd.isFavorite);
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )));
  }
}
