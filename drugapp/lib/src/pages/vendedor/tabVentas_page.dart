import 'dart:convert';
import 'package:drugapp/src/pages/vendedor/miVenta_page.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/route.dart';
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
  var venta = [];
  List<Vent> ventaData = [];
  @override
  void initState() {
    getVenta().then((venta) {
      for (var i = 0; i < venta.length; i++) {
        ventaData.add(Vent(venta[i]['id'], venta[i]['fecha'],
            venta[i]['estado'], venta[i]['total'], venta[i]['product_list']));
      }
      setState(() {
        // loadInfo = false;
      });
    });
    super.initState();
  }

  getVenta() async {
    var jsonVenta = jsonDecode(dummyVenta);
    return jsonVenta;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: bgGrey,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(
            height: medPadding * 1.6,
          ),
          Expanded(
            child: ListView(children: [
              Container(
                padding: EdgeInsets.all(
                  size.width > 850 ? medPadding * .75 : medPadding * .5),
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
      'id',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Fecha',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Estado',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      'Total',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
  DataColumn(
    label: Text(
      '',
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
  ),
];

////// Data source class for obtaining row data for PaginatedDataTable.
class VentaDataSource extends DataTableSource {
  BuildContext _context;
  dynamic _ventaData;
  VentaDataSource({
    @required List<Vent> dataVenta,
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
          DataCell(Text('${_user.id}')),
          DataCell(Text('${_user.fecha}')),
          DataCell(Text('${_user.estado}')),
          DataCell(Text('${_user.total}')),
          DataCell(InkWell(
            onTap: () => Navigator.pushNamed(
              _context,
              MiVenta.routeName,
              arguments: VentaDetallesArguments(_user),
            ),
            child: Text(
              'Ver más',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          )),
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
