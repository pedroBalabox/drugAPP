import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/model/producto_model.dart';

class CatalogState {
  List<ProductoModel> _catalog = [];

  CatalogState._();
  static CatalogState _instance = CatalogState._();
  factory CatalogState() => _instance;

  List<ProductoModel> get catalog => _catalog;

  void addToCatalog(ProductoModel itemModel) {
    _catalog.add(itemModel);
  }

void getCatalog() {
    _catalog;
  }

  void removeFromCatalog(ProductoModel itemModel) {
    for (int i = 0; i <= _catalog.length - 1; i++) {
      if (_catalog[i].idDeProducto == itemModel.idDeProducto) {
        // _catalog.remove(_catalog[i]);
        // _catalog.add(itemModel);
        _catalog.remove(_catalog[i]);
      }
      // _catalog.remove(itemModel);
    }
  }

   void removeAllCatalog() {
    _catalog = [];
  }

  void editToCatalog(ProductoModel itemModel) {
    if (itemModel == null) {
    } else {
      if (_catalog.length > 0) {
        for (int i = 0; i <= _catalog.length - 1; i++) {
          if (_catalog[i].idDeProducto == itemModel.idDeProducto) {
            // _catalog.remove(_catalog[i]);
            // _catalog.add(itemModel);
            _catalog[i].cantidad = itemModel.cantidad;
          } else if ((i == _catalog.length - 1) &
              !_catalog.any((item) =>
                  item.idDeProducto.contains(itemModel.idDeProducto))) {
            _catalog.add(itemModel);
          }
        }
      } else {
        _catalog.add(itemModel);
      }
    }
  }
}
