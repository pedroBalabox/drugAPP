// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    name,
    this.farmacia,
    this.img,
    this.fav,
    this.price,
    this.precioOferta,
    this.fecha,
    this.cantidad,
  });

  String name;
  String farmacia;
  String img;
  bool fav;
  String price;
  String precioOferta;
  String fecha;
  int cantidad;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        name: json["name"],
        farmacia: json["farmacia"],
        img: json["img"],
        fav: json["fav"],
        price: json["price"],
        precioOferta: json["precioOferta"],
        fecha: json["fecha"],
        cantidad: json["cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "farmacia": farmacia,
        "img": img,
        "fav": fav,
        "price": price,
        "precioOferta": precioOferta,
        "fecha": fecha,
        "cantidad": cantidad
      };
}
