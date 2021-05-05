import 'dart:convert';
import 'package:drugapp/model/producto_model.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawerVendedor_widget.dart';
import 'package:flutter/material.dart';


class MiVenta extends StatefulWidget {
  static const routeName = '/farmacia/detalles-de-venta';

  final dynamic miVenta;
  MiVenta({Key key, @required this.miVenta}) : super(key: key);

  @override
  _MiVentaState createState() => _MiVentaState();
}

class _MiVentaState extends State<MiVenta> {
  var venta = [];
  List<ProductModel> ventaData = [];

  @override
  void initState() {
    getVenta().then((venta) {
      for (var i = 0; i < venta.length; i++) {
        ventaData.add(ProductModel.fromJson(venta[i]));
      }
      setState(() {
        // loadInfo = false;
      });
    });
    super.initState();
  }

  getVenta() async {
    var jsonVenta = jsonDecode(dummyProd);
    return jsonVenta;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ResponsiveAppBarVendedor(
      screenWidht: size.width,
      body: body(),
      title: 'Detalles de venta ${widget.miVenta.jsonVenta.id}',
    );
  }

  body() {
    return Container(
      color: bgGrey,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: medPadding * .75, vertical: medPadding * .75),
                color: bgGrey,
                width: MediaQuery.of(context).size.width / 6,
                child: misVentas(),
              ),
              footerVendedor(context),
            ]),
          ),
        ],
      ),
    );
  }

  misVentas() {
    return PaginatedDataTable(
        // headingRowHeight: 70,
        header: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Folio: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.miVenta.jsonVenta.id,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).primaryColor)),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Estado: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.miVenta.jsonVenta.estado,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).primaryColor)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Fecha: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.miVenta.jsonVenta.fecha,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).primaryColor)),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Total: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '\$' + widget.miVenta.jsonVenta.total,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).primaryColor)),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.black26),
          ],
        
        ),
        showCheckboxColumn: false,
        columns: kTableColumns,
        source: VentaDataSource(mycontext: context, dataVenta: ventaData)
        // dataCat: searchList.length == 0 ? userData : searchList),
        );
  }

  search() {
    return Container(
      height: 35,
      child: TextField(
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(0)),
            hintStyle: TextStyle(),
            hintText: 'Buscar venta por folio...',
            fillColor: bgGrey,
            filled: true),
      ),
    );
  }
}

////// Columns in table.
const kTableColumns = <DataColumn>[
  DataColumn(
    label: Text(
      'Nombre',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Marca/Laboratorio',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Precio unitario',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Cantidad',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Subtotal',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
];

////// Data source class for obtaining row data for PaginatedDataTable.
class VentaDataSource extends DataTableSource {
  BuildContext _context;
  dynamic _ventaData;
  VentaDataSource({
    @required List<ProductModel> dataVenta,
    @required BuildContext mycontext,
  })  : _ventaData = dataVenta,
        _context = mycontext,
        assert(dataVenta != null);

  // VentaDataSource({@required User userData}) : _vendedorData = userData;

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);

    if (index >= _ventaData.length) {
      return null;
    }
    final _user = _ventaData[index];

    Icon iconStatus;

    return DataRow.byIndex(
        index: index, // DONT MISS THIS
        onSelectChanged: (bool value) {
          // _dialogCall(_context, _user.categoria_id, _user);
          print(value);
        },
        cells: <DataCell>[
          DataCell(Text('${_user.name}')),
          DataCell(Text('${_user.farmacia}')),
          DataCell(Text('${_user.price}')),
          DataCell(Text('${_user.price}')),
           DataCell(Text('${_user.precioOferta}')),
        ]);
  }

  // Future<void> _dialogCall(BuildContext context, idCat, catInfo) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return DialogInfo(
  //           catId: idCat,
  //           categoryInfo: catInfo,
  //         );
  //       });
  // }

  @override
  int get rowCount => _ventaData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
