import 'dart:async';

import 'package:drugapp/model/producto_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/state_product.dart';

class CatalogBloc {
  CatalogState _catalogState = CatalogState();

  StreamController<CatalogEvent> _input = StreamController();
  StreamController<List<ProductModel>> _output =
      StreamController<List<ProductModel>>.broadcast();

  StreamSink<CatalogEvent> get sendEvent => _input.sink;
  Stream<List<ProductModel>> get catalogStream => _output.stream;

  CatalogBloc() {
    _input.stream.listen(_onEvent);
  }

  void _onEvent(CatalogEvent event) {
    if (event is AddCatalogItemEvent) {
      _catalogState.addToCatalog(event.item);
    } else if (event is RemoveCatalogItemEvent) {
      _catalogState.removeFromCatalog(event.item);
    } else if (event is EditCatalogItemEvent) {
      _catalogState.editToCatalog(event.item);
    }

    _output.add(_catalogState.catalog);
  }

  void dispose() {
    _input.close();
    _output.close();
  }
}
