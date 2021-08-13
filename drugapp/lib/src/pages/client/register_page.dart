import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/buttom_widget.dart';
import 'package:drugapp/src/widget/input_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';

class ClientType {
  const ClientType(this.id, this.name);

  final String name;
  final String id;
}

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name;
  String first_lastname;
  String second_lastname;
  String mail;
  String password;
  String perfilCliente;

  ClientType clientType;

  List<ClientType> listaClientType = [];

  @override
  void initState() {
    super.initState();
    listaClientType.add(ClientType('general', 'Público en general'));
    listaClientType.add(ClientType('general_doctor', 'Médico General'));
    listaClientType.add(ClientType('specialist_doctor', 'Médico Especialista'));
    listaClientType.add(ClientType('professional', 'Profesional de la salud'));
    listaClientType.add(ClientType('general_pharmacy', 'Farmacia General'));
    listaClientType
        .add(ClientType('specialized_pharmacy', 'Farmacia especializada'));
    listaClientType.add(ClientType('clinic', 'Clínica'));
    listaClientType.add(ClientType('hospital', 'Hospital'));
    listaClientType.add(ClientType('health_company', 'Empresa Sector Salud'));
    listaClientType.add(ClientType('distributor', 'Distribuidor Farmacéutico'));
    listaClientType.add(ClientType('wholesaler', 'Mayorista Farmacéutico'));
    listaClientType.add(ClientType('retailer', 'Minorista Farmacéutico'));
    listaClientType.add(ClientType('importer', 'Importadora'));
    listaClientType.add(ClientType('marketer', 'Comercializadora'));
    clientType = listaClientType[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          MediaQuery.of(context).size.width < 700 ? false : true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: MediaQuery.of(context).size.width < 700
            ? Theme.of(context).primaryColor
            : Colors.white.withOpacity(0.0),
        title: Text(
          '',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return constraints.maxWidth < 700
            ? CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Column(
                        children: [
                          Container(
                            height: 150,
                            child: Stack(children: [
                              Image.asset(
                                'images/clientbg.png',
                                fit: BoxFit.cover,
                                width: double.maxFinite,
                                height: 400,
                              ),
                              Opacity(
                                  opacity: 0.6,
                                  child: Image.asset('images/coverColor.png',
                                      width: double.maxFinite,
                                      height: 400,
                                      fit: BoxFit.cover)),
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: 'Somos ',
                                        style: TextStyle(
                                            fontSize: constraints.maxWidth < 700
                                                ? 22
                                                : 47,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Drug.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Text('Todas tus marcas de confianza.',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: constraints.maxWidth < 700
                                                ? 22
                                                : 47,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          _formContainer(constraints)
                        ],
                      ),
                      childCount: 1,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 5,
                    child: Stack(fit: StackFit.expand, children: [
                      Image.asset(
                        'images/clientbg.png',
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: 400,
                      ),
                      Opacity(
                          opacity: 0.6,
                          child: Image.asset('images/coverColor.png',
                              width: double.maxFinite,
                              height: 400,
                              fit: BoxFit.cover)),
                      _infoContainer(constraints)
                    ]),
                  ),
                  Flexible(flex: 4, child: _formContainer(constraints)),
                ],
              );
      }),
    );
  }

  _formContainer(constraints) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/coverBlanco.png'))),
        child: ListView(
          shrinkWrap: true,
          physics: constraints.maxWidth > 700
              ? null
              : NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 1000 ? 30 : 85,
                  vertical: constraints.maxWidth < 1000 ? 10 : 30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getAsset(
                        'logoDrug.png', MediaQuery.of(context).size.height / 7),
                    SizedBox(height: medPadding),
                    Text(
                      'Regístrate',
                      style:
                          TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: medPadding),
                    _formReg(),
                    SizedBox(height: medPadding),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '¿Ya tienes cuenta?, ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Dirígite aqui',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ));
  }

  _formReg() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Nombre', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.words,
            tipo: 'nombre',
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.lock_outline, 'Primer apellido', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'apellido',
            onChanged: (value) {
              setState(() {
                first_lastname = value;
              });
            },
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(context, Icons.lock_outline,
                'Segundo apellido (opcional)', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'opcional',
            requerido: false,
            onChanged: (value) {
              setState(() {
                second_lastname = value;
              });
            },
          ),
          EntradaTextoTest(
            longMaxima: 100,
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Correo', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            tipo: 'correo',
            onChanged: (value) {
              setState(() {
                mail = value;
              });
            },
          ),
          SizedBox(
            height: smallPadding / 2,
          ),
          MediaQuery.of(context).size.width > 500
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: smallPadding,
                    ),
                    Icon(Icons.store_outlined, color: Color(0xFF3F9FB1)),
                    SizedBox(
                      width: smallPadding,
                    ),
                    Text(
                      'Perfil de cliente',
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                    SizedBox(
                      width: smallPadding,
                    ),
                    DropdownButton<ClientType>(
                      value: clientType,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 15,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black87),
                      underline: Container(
                        height: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      onChanged: (ClientType newValue) {
                        setState(() {
                          clientType = newValue;
                        });
                      },
                      items: listaClientType.map((ClientType type) {
                        return new DropdownMenuItem<ClientType>(
                          value: type,
                          child: new Text(
                            type.name,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: smallPadding,
                    ),
                    Row(children: [
                      SizedBox(
                        width: smallPadding,
                      ),
                      Icon(Icons.store_outlined, color: Color(0xFF3F9FB1)),
                      SizedBox(
                        width: smallPadding,
                      ),
                      Text(
                        'Perfil de cliente',
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                      // SizedBox(
                      //   width: smallPadding,
                      // ),
                    ]),
                    DropdownButton<ClientType>(
                      value: clientType,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 15,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black87),
                      underline: Container(
                        height: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      onChanged: (ClientType newValue) {
                        setState(() {
                          clientType = newValue;
                        });
                      },
                      items: listaClientType.map((ClientType type) {
                        return new DropdownMenuItem<ClientType>(
                          value: type,
                          child: new Text(
                            type.name,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
          /* Drop down  */

          // DropdownButtonFormField<String>(
          //   isExpanded: true,
          //   iconEnabledColor: Theme.of(context).primaryColor,
          //   hint: Text(
          //     "Selecciona una opción",
          //   ),
          //   decoration: InputDecoration(
          //       // icon: Icon(Icons.store_outlined, color: Color(0xFF3F9FB1)),
          //       ),
          //   value: perfilCliente,
          //   items: <String>[
          //     'Paciente',
          //     'Público en general',
          //     'Médico General',
          //     'Médico Especialista',
          //     'Profesional de la Salud',
          //     'Farmacia General',
          //     'Farmacia Especializada',
          //     'Clínica',
          //     'Hospital',
          //     'Empresa Sector Salud',
          //     'Distribuidor Farmacéutico',
          //     'Mayorista Farmacéutico',
          //     'Minorista Farmacéutico',
          //     'Importadora',
          //     'Comercializadora'
          //   ].map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Container(
          //         child: Padding(
          //           padding: EdgeInsets.only(left: 7),
          //           child: Row(
          //             children: [
          //               /* Icon(Icons.store_outlined), */
          //               // SizedBox(
          //               //   width: 7,
          //               // ),
          //               Text(value.toString()),
          //             ],
          //           ),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          //   onChanged: (String val) {
          //     setState(() {
          //       // tipoPersona = val;
          //       perfilCliente = val;
          //     });
          //   },
          // ),
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.lock_outline, 'Contraseña', null),
            tipoEntrada: TextInputType.visiblePassword,
            textCapitalization: TextCapitalization.none,
            action: TextInputAction.done,
            tipo: 'password',
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          SizedBox(height: medPadding),
          InkWell(
            onTap: () =>
                launchURL('https://drugsiteonline.com/aviso-de-privacidad/'),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Al crear tu cuenta aceptas estar deacuerdo con nuestro ',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey),
                children: <TextSpan>[
                  TextSpan(
                      text: 'aviso de privacidad.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            ),
          ),
          SizedBox(height: smallPadding * 1.25),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
            child: BotonRestTest(
                url: '$apiUrl/registro/usuario',
                method: 'post',
                formkey: formKey,
                arrayData: {
                  'name': name,
                  'first_lastname': first_lastname,
                  'second_lastname': second_lastname,
                  'mail': '$mail',
                  'password': '$password',
                  'type': 'client',
                  'client_tag': clientType.id
                  /* "perfil": 'perfilCliente', */
                },
                contenido: Text(
                  'Crear cuenta',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                action: (value) => Navigator.pushNamed(context, '/login'),
                errorStyle: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w600,
                ),
                estilo: estiloBotonPrimary),
          ),
        ],
      ),
    );
  }

  _infoContainer(constraints) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth < 800 ? 30 : 55.0,
          vertical: constraints.maxWidth < 700
              ? 30
              : MediaQuery.of(context).size.width / 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: 'Somos ',
                style: TextStyle(
                    fontSize: constraints.maxWidth < 700 ? 20 : 47,
                    fontWeight: FontWeight.w100,
                    color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Drug.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ),
          Flexible(
            child: Text('Productos para la Salud, en un solo lugar.',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: constraints.maxWidth < 800 ? 17 : 30,
                    fontWeight: FontWeight.w100,
                    color: Colors.white)),
          ),
          constraints.maxWidth < 700
              ? Container()
              : Flexible(
                  child: Text('Todas tus marcas de confianza.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: constraints.maxWidth < 800 ? 17 : 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
          SizedBox(height: smallPadding),
          constraints.maxWidth < 700
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: SimpleButtom(
                        gcolor: gradientWhite,
                        mainText: 'Aviso de privacidad',
                        textWhite: false,
                        pressed: () => launchURL('https://drugsiteonline.com/aviso-de-privacidad/'),
                      ),
                    ),
                    Flexible(flex: 2, child: SizedBox(width: medPadding)),
                    Flexible(
                      flex: 2,
                      child: SimpleButtom(
                        gcolor: gradientBlueLight,
                        mainText: 'Condiciones de uso',
                        textWhite: true,
                        pressed: () => launchURL('https://drugsiteonline.com/terminos-y-condiciones/'),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

/* drop down perfil cliente */
/* 
class clientDropdownWidget extends StatefulWidget {
  const clientDropdownWidget({Key key}) : super(key: key);

  @override
  State<clientDropdownWidget> createState() => _clientDropdownWidget();
}

class _clientDropdownWidget extends State<clientDropdownWidget> {
  String filterValue = 'Paciente';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: filterValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 16,
      elevation: 16,
      style: const TextStyle(color: Colors.black87),
      underline: Container(
        height: 2,
        color: Color(0xFF3F9FB1),
      ),
      onChanged: (String newValue) {
        setState(() {
          filterValue = newValue;
        });
      },
      items: <String>[
        'Paciente',
        'Público en general',
        'Médico General',
        'Médico Especialista',
        'Profesional de la Salud',
        'Farmacia General',
        'Farmacia Especializada',
        'Clínica',
        'Hospital',
        'Empresa Sector Salud',
        'Distribuidor Farmacéutico',
        'Mayorista Farmacéutico',
        'Minorista Farmacéutico',
        'Importadora',
        'Comercializadora'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
 */