// To parse this JSON data, do
//
//     final ordenModel = ordenModelFromJson(jsonString);

import 'dart:convert';

OrdenModel ordenModelFromJson(String str) =>
    OrdenModel.fromJson(json.decode(str));

String ordenModelToJson(OrdenModel data) => json.encode(data.toJson());

class OrdenModel {
  OrdenModel({
    this.cliente,
    this.mail,
    this.phone,
    this.id,
    this.idDeOrden,
    this.clientUserId,
    this.cantidadDeProductos,
    this.montoTotal,
    this.costoEnvio,
    this.estatusDeOrden,
    this.archivoRecetaMedica,
    this.calle,
    this.colonia,
    this.numeroExterior,
    this.numeroInterior,
    this.codigoPostal,
    this.referencias,
    this.telefonoContacto,
    this.estatusDeEnvio,
    this.comentarios,
    this.status,
    this.fechaDeCreacion,
  });

  String cliente;
  String mail;
  String phone;
  String id;
  String idDeOrden;
  String clientUserId;
  String cantidadDeProductos;
  String montoTotal;
  String costoEnvio;
  String estatusDeOrden;
  String archivoRecetaMedica;
  String calle;
  String colonia;
  String numeroExterior;
  String numeroInterior;
  String codigoPostal;
  String referencias;
  String telefonoContacto;
  String estatusDeEnvio;
  String comentarios;
  String status;
  String fechaDeCreacion;

  factory OrdenModel.fromJson(dynamic json) => OrdenModel(
        cliente: json["cliente"],
        mail: json["mail"],
        phone: json["phone"],
        id: json["id"],
        idDeOrden: json["id_de_orden"],
        clientUserId: json["client_user_id"],
        cantidadDeProductos: json["cantidad_de_productos"],
        montoTotal: json["monto_total"],
        costoEnvio: json["costo_envio"],
        estatusDeOrden: json["estatus_de_orden"],
        archivoRecetaMedica: json["archivo_receta_medica"],
        calle: json["calle"],
        colonia: json["colonia"],
        numeroExterior: json["numero_exterior"],
        numeroInterior: json["numero_interior"],
        codigoPostal: json["codigo_postal"],
        referencias: json["referencias"],
        telefonoContacto: json["telefono_contacto"],
        estatusDeEnvio: json["estatus_de_envio"],
        comentarios: json["comentarios"],
        status: json["status"],
        fechaDeCreacion: json["fecha_de_creacion"],
      );

  Map<String, dynamic> toJson() => {
        "cliente": cliente,
        "mail": mail,
        "phone": phone,
        "id": id,
        "id_de_orden": idDeOrden,
        "client_user_id": clientUserId,
        "cantidad_de_productos": cantidadDeProductos,
        "monto_total": montoTotal,
        "costo_envio": costoEnvio,
        "estatus_de_orden": estatusDeOrden,
        "archivo_receta_medica": archivoRecetaMedica,
        "calle": calle,
        "colonia": colonia,
        "numero_exterior": numeroExterior,
        "numero_interior": numeroInterior,
        "codigo_postal": codigoPostal,
        "referencias": referencias,
        "telefono_contacto": telefonoContacto,
        "estatus_de_envio": estatusDeEnvio,
        "comentarios": comentarios,
        "status": status,
        "fecha_de_creacion": fechaDeCreacion,
      };
}
