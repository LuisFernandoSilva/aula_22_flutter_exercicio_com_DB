import 'dart:io';

import 'package:aula_22_flutter_exercicio/database/data_base.dart';
import 'package:aula_22_flutter_exercicio/entity/product.dart';
import 'package:aula_22_flutter_exercicio/pages/items/item_page.dart';
import 'package:aula_22_flutter_exercicio/repositories/product_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class RegProductPage extends StatefulWidget {
  static String routeName = '/reg_products';

  @override
  _RegProductPageState createState() => _RegProductPageState();
}

class _RegProductPageState extends State<RegProductPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  final productRepository = ProductRepository(Db());
  final _imagePicker = ImagePicker();
  bool edit = true;
  Product _product = Product();
  String pathImage;
  File _image;
  TextEditingController _nameController;
  TextEditingController _descrController;

  @override
  void dispose() {
    _nameController.dispose();
    _descrController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final product = ModalRoute.of(context).settings.arguments as Product;

    _nameController = TextEditingController(text: product?.name ?? '');
    _descrController = TextEditingController(text: product?.description ?? '');

    _product.photo = product?.photo ?? null;
    _product.id = product?.id ?? null;
  }

  Future<void> _photo(ImageSource source) async {
    var _pickedFile = await _imagePicker.getImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1024,
    );
    if (_pickedFile != null) {
      setState(() {
        _image = File(_pickedFile.path);
        _product.photo = _image.path;
      });
    }
  }

  void saveProduct() async {
    final saved = await productRepository.saveProduct(_product);
    productRepository.recoverProduct();

    if (!saved) {
      showSnackBar('Não foi possível salvar a tarefa!');
      return;
    }
    Navigator.of(context).pushNamed(ItemPage.routeName);
    //Navigator.of(context).pop(_product);
  }

  void updateProduct() async {
    final update = await productRepository.updateProduct(_product);
    if (!update) {
      showSnackBar('Não foi possível atualizar a tarefa!');
      return;
    }
    Navigator.of(context).pushNamed(ItemPage.routeName);
    //Navigator.of(context).pop(_product);
  }

  void showSnackBar(String mensage) {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(
            seconds: 2,
          ),
          content: Text(
            mensage,
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.red,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (_product.photo == null) {
      _product.photo = 'assets/warning.png';
      edit = false;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cadastro Produto'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _image == null
                        ? Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: FadeInImage(
                                placeholder: AssetImage('assets/warning.png'),
                                image: AssetImage(
                                    _product?.photo ?? 'assets/warning.png'),
                              ),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: 16 / 9,
                            child: FadeInImage(
                              placeholder: AssetImage('assets/loading.gif'),
                              image: FileImage(_image),
                            ),
                          ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton.icon(
                          onPressed: () {
                            _photo(ImageSource.camera);
                          },
                          icon: Icon(Icons.photo_camera),
                          label: Text('Tirar'),
                        ),
                        SizedBox(width: 8),
                        RaisedButton.icon(
                          onPressed: () {
                            _photo(ImageSource.gallery);
                          },
                          icon: Icon(Icons.photo_library),
                          label: Text('Galeria'),
                        ),
                      ],
                    ),
                    Divider(),
                    Form(
                      key: _form,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Nome',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.length < 3) return 'nome muito curto';
                          if (value.length > 30) return 'nome muito longo';
                          return null;
                        },
                        onChanged: (value) {
                          _product.name = value;
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _descrController,
                      decoration: InputDecoration(
                          hintText: 'Descrição', border: OutlineInputBorder()),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      validator: (value) {
                        if (value.length < 3) return 'Descrição muito curta';
                        if (value.length > 100) return 'Descrição muito longo';
                        return null;
                      },
                      onChanged: (value) {
                        _product.description = value;
                      },
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 40,
                  child: OutlineButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                    borderSide: BorderSide(color: Colors.blue),
                    focusColor: Colors.red,
                  ),
                ),
                SizedBox(width: 16),
                edit
                    ? Expanded(
                        flex: 60,
                        child: OutlineButton(
                          child: Text('Editar'),
                          onPressed: () {
                            if (_product.photo == null) {
                              showSnackBar('Precisa de uma foto');
                            }

                            if (!_form.currentState.validate()) {
                              showSnackBar('Dados inválidos!');
                              return;
                            }
                            _form.currentState.save();
                            updateProduct();
                          },
                          borderSide: BorderSide(color: Colors.blue),
                          focusColor: Colors.red,
                        ),
                      )
                    : Expanded(
                        flex: 60,
                        child: OutlineButton(
                          child: Text('Salvar'),
                          onPressed: () {
                            _product.photo = _image.path;
                            if (!_form.currentState.validate()) {
                              showSnackBar('Dados inválidos!');
                              return;
                            }
                            _form.currentState.save();
                            saveProduct();
                          },
                          borderSide: BorderSide(color: Colors.blue),
                          focusColor: Colors.red,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
