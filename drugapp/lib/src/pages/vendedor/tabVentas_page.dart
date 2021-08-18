import 'dart:convert';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

////// Data class.s
class Vent {
  Vent(this.id, this.fecha, this.estado, this.total, this.product_list);
  final String id;
  final String fecha;
  final String estado;
  final String total;
  final String product_list;
}

class TabVentas extends StatefulWidget {
  TabVentas({Key key}) : super(key: key);

  @override
  _TabVentasState createState() => _TabVentasState();
}

class _TabVentasState extends State<TabVentas> {
  List<Vent> ventaData = [];

  var orden;

  var jsonOrden;
  var jsonTienda;

  RestFun rest = RestFun();

  String errorStr;
  bool load = true;
  bool error = false;

  List searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    sharedPrefs.init();
    getTienda();
  }

  getTienda() {
    rest
        .restService('', '${urlApi}obtener/mi-farmacia',
            sharedPrefs.partnerUserToken, 'get')
        .then((value) {
      if (value['status'] == 'server_true') {
        setState(() {
          jsonTienda = jsonDecode(value['response']);
        });
        getProductos();
      } else {
        setState(() {
          load = false;
          error = true;
          errorStr = value['message'];
        });
      }
    });
  }

  getProductos() async {
    var arrayData = {"farmacia_id": jsonTienda[1]['farmacia_id']};
    await rest
        .restService(arrayData, '${urlApi}obtener/ordenes',
            sharedPrefs.partnerUserToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        var ordenResp = value['response'];
        ordenResp = jsonDecode(ordenResp)[1]["ordenes"];
        setState(() {
          orden = ordenResp;
          // orden = ordenResp.values.toList();
          load = false;
        });
      } else {
        setState(() {
          load = false;
          error = true;
          errorStr = value['message'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        color: bgGrey,
        height: MediaQuery.of(context).size.height,
        child: load
            ? bodyLoad(context)
            : error
                ? errorWidget(errorStr, context)
                : Column(
                    children: [
                      SizedBox(
                        height: medPadding * 1.6,
                      ),
                      Expanded(
                        child: ListView(children: [
                          Container(
                            padding: EdgeInsets.all(size.width > 850
                                ? medPadding * .75
                                : medPadding * .5),
                            color: bgGrey,
                            width: MediaQuery.of(context).size.width / 6,
                            child: misVentas(),
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(size.width > 850
                          //       ? medPadding * .75
                          //       : medPadding * .5),
                          //   color: bgGrey,
                          //   width: MediaQuery.of(context).size.width / 6,
                          //   child: showResumenFinanciero(),
                          // ),
                          footerVendedor(context),
                        ]),
                      ),
                    ],
                  ));
  }

  misVentas() {
    return PaginatedDataTable(
        actions: [
          IconButton(
              onPressed: () => _showYearMonthPicker(context),
              icon: Icon(Icons.download))
        ],
        // rowsPerPage: 7,
        header: MediaQuery.of(context).size.width > 700
            ? Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 5,
                    child: search(),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(),
                  )
                ],
              )
            : search(),
        showCheckboxColumn: false,
        columns: kTableColumns,
        source: DataSource(
            mycontext: context, dataData: _isSearching ? searchList : orden)
        // dataCat: searchList.length == 0 ? userData : searchList),
        );
  }

  void searchOperation(String searchText) {
    searchList.clear();
    _handleSearchStart();
    if (_isSearching != null) {
      for (int i = 0; i < orden.length; i++) {
        String dataId = orden[i]['id_de_orden'];
        String dataProducto = orden[i]['id_de_producto'];
        String nombreProducto = orden[i]['nombre'];
        if (dataId.toLowerCase().contains(searchText.toLowerCase()) ||
            dataProducto.toLowerCase().contains(searchText.toLowerCase()) ||
            nombreProducto.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            searchList.add(orden[i]);
          });
        }
      }
    }
  }

  Future<void> _showYearMonthPicker(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Descargar reporte de ventas',
            style: TextStyle(color: Colors.black87),
          ),
          content: Container(
            height: 80,
            child: Column(
              children: [
                Container(
                  child: Text(
                      "Selecciona un mes y un año para descargar el reporte de ventas"),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text("Seleccionar fecha"),
                    ))
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showMonthPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 10),
        lastDate: DateTime(DateTime.now().year + 2));
    if (picked != null) {
      setState(() {
        //print(picked.month);
        //print(picked.year);
        //print(sharedPrefs.partnerUserToken);
        launchURL(apiUrl+'/report-store.php?DrJWT=' +
            sharedPrefs.partnerUserToken+
            "&farmacia_id=" +
            jsonTienda[1]['farmacia_id'] +
            "&year=" +
            picked.year.toString() +
            "&month=" +
            picked.month.toString());
        //bannerModel.fechaDeExposicion = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  search() {
    return Container(
      height: 35,
      child: TextField(
        onChanged: (value) => searchOperation(value),
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
            hintText: 'Buscar venta por folio ó producto...',
            fillColor: bgGrey,
            filled: true),
      ),
    );
  }

  showResumenFinanciero() {
    return Container(
      height: 100,
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 6,
      child: Column(
        children: [
          Text(
            'Resumen financiero',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total ventas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'Total por recibir',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'Retenciones',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'Total pagado a tienda',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    '\$30,000.00 ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '\$ ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '\$ ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '\$ ',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

////// Columns in table.
const kTableColumns = <DataColumn>[
  DataColumn(
    label: Text(
      'ID de Orden',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Producto',
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
      'Costo Unitario',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Costo Total',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      '¿Aplicó mayoreo?',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Costo Final',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Estatus',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Fecha de creación',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
];

////// Data source class for obtaining row data for PaginatedDataTable.
class DataSource extends DataTableSource {
  BuildContext _context;
  dynamic _ventaData;
  DataSource({
    @required List<dynamic> dataData,
    @required BuildContext mycontext,
  })  : _ventaData = dataData,
        _context = mycontext,
        assert(dataData != null);

  // DataSource({@required User userData}) : _vendedorData = userData;

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
        onSelectChanged: (bool value) {},
        cells: <DataCell>[
          DataCell(Text('${_user['id_de_orden']}')),
          DataCell(Container(
            width: 200,
            child: Text('${_user['nombre']}'),
          )),
          DataCell(Text('${_user['cantidad']}')),
          DataCell(Text('${_user['costo_unitario']}')),
          DataCell(Text('${_user['costo_total']}')),
          DataCell(Text('${_user['aplica_mayoreo']}')),
          DataCell(Text("\$" + _user['costo_final'])),
          DataCell(Text('${_user['status']}')),
          DataCell(Text('${_user['fecha_de_creacion']}')),
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
