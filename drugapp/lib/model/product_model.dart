// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
    ProductoModel({
        this.id,
        this.idDeProducto,
        this.farmaciaId,
        this.sku,
        this.requiereReceta,
        this.nombre,
        this.descripcion,
        this.marca,
        this.precio,
        this.precioConDescuento,
        this.precioMayoreo,
        this.cantidadMayoreo,
        this.stock,
        this.categoria,
        this.subcategoria1,
        this.subcategoria2,
        this.subcategoria3,
        this.etiqueta1,
        this.etiqueta2,
        this.etiqueta3,
        this.etiqueta4,
        this.etiqueta5,
        this.status,
        this.fechaDeCreacion,
        this.galeria,
    });

    dynamic id;
    String idDeProducto;
    String farmaciaId;
    String sku;
    String requiereReceta;
    String nombre;
    String descripcion;
    String marca;
    String precio;
    String precioConDescuento;
    String precioMayoreo;
    String cantidadMayoreo;
    String stock;
    String categoria;
    String subcategoria1;
    String subcategoria2;
    String subcategoria3;
    String etiqueta1;
    String etiqueta2;
    String etiqueta3;
    String etiqueta4;
    String etiqueta5;
    String status;
    dynamic fechaDeCreacion;
    dynamic galeria;

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["id"],
        idDeProducto: json["id_de_producto"],
        farmaciaId: json["farmacia_id"],
        sku: json["sku"],
        requiereReceta: json["requiere_receta"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        marca: json["marca"],
        precio: json["precio"],
        precioConDescuento: json["precio_con_descuento"],
        precioMayoreo: json["precio_mayoreo"],
        cantidadMayoreo: json["cantidad_mayoreo"],
        stock: json["stock"],
        categoria: json["categoria"],
        subcategoria1: json["subcategoria_1"],
        subcategoria2: json["subcategoria_2"],
        subcategoria3: json["subcategoria_3"],
        etiqueta1: json["etiqueta_1"],
        etiqueta2: json["etiqueta_2"],
        etiqueta3: json["etiqueta_3"],
        etiqueta4: json["etiqueta_4"],
        etiqueta5: json["etiqueta_5"],
        status: json["status"],
        fechaDeCreacion: json["fechaDeCreacion"],
        galeria: json["galeria"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_de_producto": idDeProducto,
        "farmacia_id": farmaciaId,
        "sku": sku,
        "requiere_receta": requiereReceta,
        "nombre": nombre,
        "descripcion": descripcion,
        "marca": marca,
        "precio": precio,
        "precio_con_descuento": precioConDescuento,
        "precio_mayoreo": precioMayoreo,
        "cantidad_mayoreo": cantidadMayoreo,
        "stock": stock,
        "categoria": categoria,
        "subcategoria_1": subcategoria1,
        "subcategoria_2": subcategoria2,
        "subcategoria_3": subcategoria3,
        "etiqueta_1": etiqueta1,
        "etiqueta_2": etiqueta2,
        "etiqueta_3": etiqueta3,
        "etiqueta_4": etiqueta4,
        "etiqueta_5": etiqueta5,
        "status": status,
        "fecha_de_creacion": fechaDeCreacion.toIso8601String(),
        "galeria": List<dynamic>.from(galeria.map((x) => x)),
    };
}
