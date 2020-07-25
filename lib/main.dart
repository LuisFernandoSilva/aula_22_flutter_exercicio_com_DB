//import 'package:aula_22_flutter_exercicio/camera.dart';
import 'package:aula_22_flutter_exercicio/pages/edit/reg_product_page.dart';
import 'package:aula_22_flutter_exercicio/pages/home/home_page.dart';
import 'package:aula_22_flutter_exercicio/pages/items/item_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (ctx) {
          return HomePage();
        },
        ItemPage.routeName: (ctx) {
          return ItemPage();
        },
        RegProductPage.routeName: (ctx) {
          return RegProductPage();
        },
      },
    );
  }
}
