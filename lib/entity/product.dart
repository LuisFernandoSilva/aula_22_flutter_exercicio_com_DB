class Product {
  int id;
  String photo;
  String name;
  String description;
  Product.empty();

  Product({this.id, this.photo, this.name, this.description});

  factory Product.ofMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      photo: map['photo'],
      name: map['name'],
      description: map['description'],
    );
  }

  Map<String, dynamic> forMap() {
    return {
      'id': id,
      'photo': photo,
      'name': name,
      'description': description,
    };
  }
}
