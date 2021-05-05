import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.user_id,
        this.mail,
        this.password,
        this.type,
        this.status,
        this.name,
        this.first_lastname,
        this.second_lastname,
        this.gender,
        this.imgUrl,
        this.ubicacion,
        this.ubicacion_lat,
        this.ubicacion_lng,
        this.fecha_nacimiento,
        this.phone
    });

    String user_id;
    String mail;
    String password;
    String type;
    String status;
    String name;
    String first_lastname;
    String second_lastname;
    String gender;
    String imgUrl;
    String ubicacion;
    String ubicacion_lat;
    String ubicacion_lng;
    String fecha_nacimiento;
    String phone;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user_id: json["user_id"],
        mail: json["mail"],
        password: json["password"],
        type: json["type"],
        status: json["status"],
        name: json["name"],
        first_lastname: json["first_lastname"],
        second_lastname: json["second_lastname"],
        gender: json["gender"],
        imgUrl: json["img_url"],
        ubicacion: json["ubicacion"],
        ubicacion_lat: json["ubicacion_lat"],
        ubicacion_lng: json["ubicacion_lng"],
        fecha_nacimiento: json["fecha_nacimiento"],
        phone: json["phone"]
    );

    Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "mail": mail,
        "password": password,
        "type": type,
        "status": status,
        "name": name,
        "first_lastname": first_lastname,
        "second_lastname": second_lastname,
        "gender": gender,
        "img_url": imgUrl,
        "ubicacion": ubicacion,
        "ubicacion_lat": ubicacion_lat,
        "ubicacion_lng": ubicacion_lng,
        "fecha_nacimiento": fecha_nacimiento,
        "phone": phone
    };
}