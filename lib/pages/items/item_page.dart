import 'package:aula_22_flutter_exercicio/database/data_base.dart';
import 'package:aula_22_flutter_exercicio/entity/product.dart';
import 'package:aula_22_flutter_exercicio/pages/edit/reg_product_page.dart';
import 'package:aula_22_flutter_exercicio/pages/home/home_page.dart';
import 'package:aula_22_flutter_exercicio/repositories/product_repository.dart';
import 'package:flutter/material.dart';

class ItemPage extends StatefulWidget {
  static String routeName = '/items';

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  ProductRepository repository;

  @override
  void initState() {
    super.initState();
    repository = ProductRepository(Db());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos '),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(HomePage.routeName);
          },
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: repository.recoverProduct(),
        initialData: null,
        builder: (ctx, snapshot) {
          if (!snapshot.hasData && !snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData && snapshot.hasError) {
            return Center(
              child: Text(snapshot.hasError.toString()),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 16 / 9,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(RegProductPage.routeName,
                        arguments: snapshot.data[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: FadeInImage(
                      placeholder: AssetImage("assets/loading.gif"),
                      image: AssetImage(snapshot.data[index].photo),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
