import 'package:drugapp/model/producto_model.dart';

class CatalogState {
  List<ProductModel> _catalog = [];

  CatalogState._();
  static CatalogState _instance = CatalogState._();
  factory CatalogState() => _instance;

  List<ProductModel> get catalog => _catalog;

  void addToCatalog(ProductModel itemModel) {
    _catalog.add(itemModel);
  }

  void removeFromCatalog(ProductModel itemModel) {
    for (int i = 0; i <= _catalog.length - 1; i++) {
      if (_catalog[i].name == itemModel.name) {
        // _catalog.remove(_catalog[i]);
        // _catalog.add(itemModel);
        _catalog.remove(_catalog[i]);
      }
      // _catalog.remove(itemModel);
    }
  }

  void editToCatalog(ProductModel itemModel) {
    if (_catalog.length > 0) {
      for (int i = 0; i <= _catalog.length - 1; i++) {
        if (_catalog[i].name == itemModel.name) {
          // _catalog.remove(_catalog[i]);
          // _catalog.add(itemModel);
          _catalog[i].cantidad = itemModel.cantidad;
        } else if ((i == _catalog.length - 1) &
            !_catalog.any((item) => item.name.contains(itemModel.name))) {
          _catalog.add(itemModel);
        }
      }
    } else {
      _catalog.add(itemModel);
    }
  }
}
