import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

import '../provider/products.dart';

class EditeProductScreen extends StatefulWidget {
  const EditeProductScreen({super.key});

  @override
  State<EditeProductScreen> createState() => _EditeProductScreenState();

  static const routName = './EditeProductScreen';
}

class _EditeProductScreenState extends State<EditeProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0.00,
  );

  @override
  void initState() {
    // TODO: implement initState
    _imageFocusNode.addListener(_updateImgUrl);
    super.initState();
  }

  var isInit = true;
  var isLoading = false;

  var initValues = {
    'title': '',
    "description": '',
    'price': '',
    'imageUrl': '',
  };
  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;

      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);

        initValues = {
          'title': _editedProduct.title!,
          "description": _editedProduct.description!,
          'price': '',
          'imageUrl': '',
        };
        _imgUrlController.text = _editedProduct.imageUrl!;
        _priceController.text = _editedProduct.price!.toString();
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void _updateImgUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
    } else {
      try {
        final productsData = Provider.of<Products>(context, listen: false);
        await productsData.addProduct(_editedProduct);
        print('product Saved succesfully');
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('An error !!'),
              content: const Text('Something went wrong,try again...!'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'))
              ],
            );
          },
        );
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImgUrl);
    _priceController.clear();
    _imgUrlController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        title: Text(productId == null ? 'Add Product' : 'Edite Product'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: initValues['title'],
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter a title.';
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text('Title'),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            title: newValue,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                          );
                        },
                      ),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Price'),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (val) {
                          if (val == '') {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(val!) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(val) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        onSaved: (newValue) {
                          try {
                            _editedProduct = Product(
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(newValue!),
                            );
                          } catch (e) {
                            print('printing error');
                            print(e.toString());
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['description'],
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter description.';
                          }
                          if (val.length < 10) {
                            return 'Description minimum ten letter.';
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text('Description'),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_imageFocusNode);
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            description: newValue,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8, top: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imgUrlController.text.isEmpty
                                  ? const SizedBox()
                                  : Image.network(
                                      _imgUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter imageUrl.';
                                  }
                                  if (!val.startsWith('http') ||
                                      !val.startsWith('https')) {
                                    return 'please enter valid url.';
                                  }

                                  return null;
                                },
                                controller: _imgUrlController,
                                decoration: const InputDecoration(
                                  label: Text('Image Url'),
                                ),
                                keyboardType: TextInputType.url,
                                focusNode: _imageFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                onSaved: (newValue) {
                                  _editedProduct = Product(
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite,
                                    imageUrl: newValue,
                                    price: _editedProduct.price,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 35,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            _saveForm();
                          },
                          child: const Text('Save'),
                        ),
                      )
                    ],
                  )),
            ),
    );
  }
}
