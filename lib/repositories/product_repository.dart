import 'package:aula_22_flutter_exercicio/database/data_base.dart';
import 'package:aula_22_flutter_exercicio/entity/product.dart';

class ProductRepository {
  final Db _db;
  ProductRepository(this._db);
  String errorDb;

  Future<bool> saveProduct(Product product) async {
    try {
      var instanceDB = await _db.recoverInstance();
      var result = await instanceDB.insert('product', product.forMap());
      return result > 0;
    } catch (e) {
      errorDb = e;
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      var instanceDB = await _db.recoverInstance();
      var result = await instanceDB.update('product', product.forMap(),
          where: 'id = ?', whereArgs: [product.id]);

      return result > 0;
    } catch (e) {
      errorDb = e;
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      var instanceDB = await _db.recoverInstance();
      var result =
          await instanceDB.delete('product', where: 'id = ?', whereArgs: [id]);

      return result > 0;
    } catch (e) {
      errorDb = e;
      return false;
    }
  }

  Future<List<Product>> recoverProduct() async {
    try {
      await Future.delayed(Duration(seconds: 3));
      var instanceDB = await _db.recoverInstance();
      final result = await instanceDB.query('product');
      var products = result.map((e) => Product.ofMap(e))?.toList();

      return products ?? [];
    } catch (e) {
      errorDb = e;
      return e;
    }
  }
}
