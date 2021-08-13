import 'package:drugapp/src/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';

class PreguntasFrec extends StatefulWidget {
  PreguntasFrec({Key key}) : super(key: key);

  @override
  _PreguntasFrecState createState() => _PreguntasFrecState();
}

class _PreguntasFrecState extends State<PreguntasFrec> {
  final testData = ["Example1", "Example2", "Example3", "Example100"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _markDownData =
        testData.map((x) => "- $x\n").reduce((x, y) => "$x$y");

    return ResponsiveAppBar(
        screenWidht: MediaQuery.of(context).size.width,
        body: bodyCuenta(),
        title: "Preguntas frecuentes");
  }

  bodyCuenta() {
    var size = MediaQuery.of(context).size;

    return Container(
      color: bgGrey,
      // padding: EdgeInsets.all(medPadding),
      child: ListView(padding: EdgeInsets.all(medPadding), children: [
        Text(
          'Preguntas frecuentes',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        Accordion(
            '¿Qué es Drug?',
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Es la marketplace de Productos para la Salud más grande del Mundo. El cual funciona bajo el modelo de”Safe Market” (Mercado Seguro). Lo cual significa que todas las transacciones realizadas mediante nuestra Tienda, tienen una trazabilidad y vigilancia por tratarse de fármacos y derivados.  Desde el Laboratorio fabricante hasta la entrega al Cliente final. Dentro de la Tienda Online encontrarás únicamente a las Marcas de Mayor acreditación y confianza en  nivel Global. Productos abastecidos directamente de Distribuidores Autorizados y por los Laboratorios Fabricantes regulados. Gracias a este Modelo digital, permite a los Usuarios comprar a un precio más económico que en Farmacias Comerciales, asi como la venta al Mayoreo para el Sector Salud. Al registrarte accederás a  todas las categorías de Salud; Medicamentos genéricos y patentes de libre venta, alta especialidad y sustancias controladas. También a las categorías de Material de Curación, Vacunas y Sueros Humanos, Equipo Médico, Instrumental así como insumos en Gral.',
                style: TextStyle(fontSize: 15),
              ),
            )),
        Accordion(
            '¿Qué ventajas hay por comprar en Drug?',
            Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• Primeramente que encontrarás todo tipo de productos para la Salud en un Solo lugar',
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                    Text(
                      '• Encontrarás tu marcas de confianza y Laboratorios de Mayor acreditación  a nivel Global',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '• Precios directo de Fabricante, más barato que en farmacias comerciales',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '• Precios de Mayoreo para Médicos, Farmacias, Hospitales , Distribuidores y Sector salud',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '• Localizamos cualquier producto para la Salud de urgencia para ti',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ))),
        Accordion(
          '¿Por qué son más baratos los productos en la tienda Drug?',
          Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                children: [
                  Text(
                    'Nuestra misión es que todo el mundo pueda acceder a comprar productos para la Salud a precios razonables, sin incrementos desmedidos. Contribuyendo asi, al fortalecimiento de su salud.',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Sobre los precios; Los productos dentro de la tienda de Drug, son abastecidos directamente por los laboratorios y fabricantes, sumado a que al tener un modelo Digital podemos minimizar los gastos operativos, reduciendo significativamente  con esto  el Precio final para nuestros Usuario.',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              )),
        ),
        Accordion(
          '¿Tienen tiendas físicas?',
          Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Actualmente Drug, opera con sucursales denominadas “Centros de Envío”. Sucursales en las cuales podrás recoger tus paquetes. No tenemos sucursales ni puntos de venta como farmacias.',
                style: TextStyle(fontSize: 15),
              )),
        ),
        Accordion(
          '¿Por qué recibo productos de más en mis pedidos?',
          Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Recuerda que sin excepción, siempre dejaremos un Regalo para ti en cada Compra!',
                style: TextStyle(fontSize: 15),
              )),
        ),
        Accordion(
          '¿Cómo puedo comprar  productos al mayoreo?',
          Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Accede al precio de Mayoreo a partir de 10 piezas en tus compras. Si el producto es de venta controlada o regulada de acuerdo a tu perfil comercial (Farmacia, médico, Hospital, Empresa) serán los documentos y permisos que solicitaremos.',
                style: TextStyle(fontSize: 15),
              )),
        ),
        Accordion(
          '¿Que tipos de productos venden en Drug?',
          Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'En la tienda Online, podrá encontrar productos. Originales y con registro, en las siguientes categorías; Medicamentos patentes y genéricos, Controlados y de alta especialidad, Vacunas y sueros humanos, Materiales de curación , Estética y Belleza, suplementos, medicina alternativa, medicina natural, y mucho más!',
                style: TextStyle(fontSize: 15),
              )),
        ),
        Accordion(
          '¿Que es Drug Recurrent?',
          Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Es un servicio premium, en el cual tienes grandes beneficios, el principal de ellos es que puedes programar tu medicamento para que se te envíe a la puerta de tu casa mes con mes y nunca te quedes sin completar tus tratamientos. Conoce más de los beneficios de este servicio Llamando al 5550150667.',
                style: TextStyle(fontSize: 15),
              )),
        ),
        Accordion(
          '¿Cómo puedo registrarme en Drug Recurrent?',
          Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: RichText(
                text: TextSpan(
                  text: 'Al realizar una Compra, selecciona la Opcion: ',
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'Repetir este pedido el siguiente mes. ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'Con esto quedarás registrado en nuestro programa Drug Recurrent, con el cual accederas a un 15% de descuento adicional. En cualquier momento podras cancelar tu suscripción al Programa de Compras recurrentes.'),
                  ],
                ),
              )),
        ),
        Accordion(
            '¿Cómo comprar en Drug?',
            Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comprar en Drug es muy fácil y seguro, sólo debes:s',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '• Registrate con tu nombre, email, ubicación y datos de facturación (en caso de requerir factura)',
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                    Text(
                      '• Busca tu producto en la barra superior (puedes buscar por nombre, sustancia, categoria, tienda, o padecimiento)',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '• Una vez que has elegido los productos que necesitas, finalizas tu compra dando clic en “Comprar Ahora”',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '• Seleccione la forma de pago que más te convenga',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '• ¡Genial!... recibirás en tu correo electrónico avisos del estatus de tu pedido.',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '• Podrás visualizar tu información de envío en el detalle de tu compra',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ))),
        Accordion(
          '¿Qué es Abasto Express de Drug?',
          Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: RichText(
                text: TextSpan(
                  text:
                      'En Drug somos conscientes de la importancia de necesitar un producto para la salud de Urgencia. Es por ello que ponemos a su disposición nuestro servicio de ',
                  children: const <TextSpan>[
                    TextSpan(
                        text: '”Abasto Express”. ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'Es un un equipo de profesionales que se encarga de localizar tu producto con el Laboratorio, Marca fabricante o con las Tiendas afiliadas a Drug. Poniéndolo a tu disposición en el menor tiempo posible hasta tu domicilio. Resolviendo en un plazo no mayor a 30 minutos. '),
                  ],
                ),
              )),
        ),
        Accordion(
          '¿Qué pasa si no encuentro un producto?',
          Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: RichText(
                text: TextSpan(
                  text:
                      'Drug agrega de manera periódica nuevos productos que salen a la venta, en caso de no tener el producto que estás buscando puedes pedirlo a nuestra área de ',
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'Abasto Express. ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'Nosotros intentaremos conseguirlo directamente con el Laboratorio Fabricante, Distribuidores autorizados o tiendas afiliadas en Drug.  Siempre y cuando no sea un producto en desabasto, descontinuado o prohibido y se encuentre aprobado para su distribución en el País de solicitud, si ese es el caso te lo comunicaremos lo antes posible. Resolviendo en un plazo no mayor a 30 minutos.')
                  ],
                ),
              )),
        ),
        Accordion(
            '¿Cuáles son los horarios de servicio y reparto?',
            Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Horario de Servicio Tienda Online: ',
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        children: const <TextSpan>[
                          TextSpan(
                              text:
                                  'Puedes levantar un pedido en nuestro sitio web los 365 días del año las 24 horas del día atra ves de nuestra tienda Online.',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Horario de Servicio Abasto Express: ',
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        children: const <TextSpan>[
                          TextSpan(
                              text:
                                  'Puedes levantar un pedido Directo a nuestra línea telefónica Express de lunes a domingo en un horario de 08:00 – 19:00 hrs',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Tiempos de Entrega: ',
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        children: const <TextSpan>[
                          TextSpan(
                              text:
                                  'En Drug contamos con 2 tipos de tiempos de entrega. Recibe en 24 hrs realizando tu pago antes de las 16:00hrs. Y entregas de 3-5 días hábiles para los pedidos programados.',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    )
                  ],
                ))),
        Accordion(
            '¿Cómo puedo darle seguimiento a mi pedido?',
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Sólo debes entrar a tu cuenta con los datos con los que te registraste en Drug, dirígete al detalle de tu compra, ahí podrás visualizar toda la Información sobre tu Envío. O si lo prefieres puedes ponerte en contacto con nosotros mediante un, estro Whatsapp Oficial correo info@drugsiteonline.com o línea de atención a clientes 5550150667 donde con gusto te resolvemos.',
                style: TextStyle(fontSize: 15),
              ),
            )),
        Accordion(
            '¿Puedo hacer compras al mayoreo?',
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Puedes acceder al Precio de Mayoreo, comprando a partir de 10 piezas, cualquier producto. Este lo podrás visualizar al seleccionar cualquier producto.',
                style: TextStyle(fontSize: 15),
              ),
            )),
        Accordion(
            'Quiero cancelar mi pedido... ¿Qué hago?',
            Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Si deseas cancelar tu pedido por favor comunícate con nosotros mediante chat, correo info@drugsiteonline.com línea de atención a clientes 5550150667, donde con gusto te ayudaremos. En caso de que hayas hecho tu pago por medio electrónico no te preocupes, procederemos a hacer tu devolución correspondiente.',
                      style: TextStyle(fontSize: 15),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Importante. ',
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        children: const <TextSpan>[
                          TextSpan(
                              text:
                                  'Solo podrás cancelar tu pedido dentro de las Primeras 24hrs de ser emitido. Impidiendo que el producto salga del almacén, de lo contrario por la Ley de Regulación Sanitaria, no podremos cancelarlo.',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ],
                ))),
        Accordion(
            '¿Puedo pagar con tarjeta? ¿Es seguro?',
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                ' ¡Claro! Es la manera más fácil y rápida de hacerlo, así no tendrás que preocuparte por el efectivo, ten la confianza de que contamos con el mejor sistema de seguridad anti fraudes. Y trabajamos con Bancos Internacionales de Confianza como lo es BBVA, SANTANDER y AFIRME.',
                style: TextStyle(fontSize: 15),
              ),
            )),
        Accordion(
            '¿Ingresé mal mi dirección, qué hago?',
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                ' Contacta INMEDIATAMENTE a nuestro equipo de solución de Servicios al 5550150667 donde con gusto te resolver y direccionar tu Paquete.',
                style: TextStyle(fontSize: 15),
              ),
            )),
        Accordion(
            '¿Por qué me estan pidiendo Fotografía de mi Identificación Oficial y Receta?',
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Drug* es una empresa regulada y apegada a las normas de Abasto y dispensación de productos para la Salud de cada País. Es por ello que vigilamos la trazabilidad del producto desde la fabricación hasta la información del cliente. Evitando así cualquier intento de Fraude o Consumos ilegales. Es por eso que a los Usuarios se les Solicita su Receta vigente y su identificación Oficial, las cuales en caso de una Investigación por parte de las Autoridades , estamos obligados a presentar.',
                style: TextStyle(fontSize: 15),
              ),
            )),
        Accordion(
            '¿Dónde puedo obtener mi factura?',
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Puedes solicitar tu Factura llamando al 5550150667, o al correo info@drugsiteonline.com',
                style: TextStyle(fontSize: 15),
              ),
            )),
        Accordion(
            '¿Cómo contactar con un Representante de Drug?',
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Para tu comodidad tenemos múltiples formas de contacto: Línea directa.5550150667. correo info@drugsiteonline.com. Whatsapp 5567026709',
                style: TextStyle(fontSize: 15),
              ),
            )),
        Accordion(
            '¿Qué hago si tengo una reacción adversa con algún medicamento?',
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Con el fin de poder reportar oportunamente eventos adversos con algún medicamento te pedimos lo notifiques  inmediatamente a nuestra línea de atención 5550150667. O Directamente a la Cofepris en México. 8000335050',
                style: TextStyle(fontSize: 15),
              ),
            )),
        Accordion(
            '¿Cómo puedo vender en La Tienda de Drug?',
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Envía tu solicitud a info@drugsiteonline.com con el asunto. Solicitud de apertura de tienda. Y nuestro Category Manager te atenderá.',
                style: TextStyle(fontSize: 15),
              ),
            )),
      ]),
    );
  }
}

class Accordion extends StatefulWidget {
  final String title;
  final Widget content;

  Accordion(this.title, this.content);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              title: Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(
                  _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _showContent = !_showContent;
                  });
                },
              ),
            ),
            _showContent ? widget.content : Container()
          ]),
    );
  }
}
