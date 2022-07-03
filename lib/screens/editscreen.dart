import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class EditScreen extends StatefulWidget {
  static const routeName = '/edit-screen';
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _firsinit = true;

  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      imageUpdate();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_firsinit) {
      final prodId = ModalRoute.of(context)!.settings.arguments as String?;
      if (prodId != null) {
        _editedProduct =
            Provider.of<ProductList>(context, listen: false).byId(prodId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _firsinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(() {
      imageUpdate();
    });
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void save() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (_editedProduct.id != '') {
      Provider.of<ProductList>(context, listen: false)
          .updateProduct(_editedProduct);
    } else {
      Provider.of<ProductList>(context, listen: false).addItem(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  void imageUpdate() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit'),
          actions: [IconButton(onPressed: save, icon: const Icon(Icons.save))],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    initialValue: _initValues['title'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a title';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id,
                        title: value.toString(),
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                  ),
                  TextFormField(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                    initialValue: _initValues['price'],
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please provide a valid number';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Price must be at least more than 0';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value.toString()),
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                  ),
                  TextFormField(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    initialValue: _initValues['description'],
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a description';
                      }
                      if (value.length < 10) {
                        return 'Description must have at least 10 charactes';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: value.toString(),
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, right: 10),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white)),
                        child: _imageUrlController.text.isEmpty
                            ? const Center(child: Text('Enter URL'))
                            : Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),

                          keyboardType: TextInputType.url,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide an URL';
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'Plese provide a valid URL';
                            }
                            if (!value.endsWith('png') &&
                                !value.endsWith('jpg') &&
                                !value.endsWith('jpeg')) {
                              return 'Plese provide a valid URL';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            save();
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: value.toString(),
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
