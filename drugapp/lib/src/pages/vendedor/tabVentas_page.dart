import 'dart:convert';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:flutter/material.dart';

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
        ordenResp = jsonDecode(ordenResp)[1];
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
                          footerVendedor(context),
                        ]),
                      ),
                    ],
                  ));
  }

  misVentas() {
    return PaginatedDataTable(
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
        source: DataSource(mycontext: context, dataData: _isSearching ? searchList : orden)
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
        if (dataId.toLowerCase().contains(searchText.toLowerCase()) ||
            dataProducto.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            searchList.add(orden[i]);
          });
        }
      }
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
}

////// Columns in table.
const kTableColumns = <DataColumn>[
  DataColumn(
    label: Text(
      'Folio',
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
      'Mayoreo',
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
      'Fecha',
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
          DataCell(Text('${_user['id_de_producto']}')),
          DataCell(Text('${_user['cantidad']}')),
          DataCell(Text('${_user['costo_unitario']}')),
          DataCell(Text('${_user['costo_total']}')),
          DataCell(Text('${_user['aplica_mayoreo']}')),
          DataCell(Text('${_user['costo_final']}')),
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
