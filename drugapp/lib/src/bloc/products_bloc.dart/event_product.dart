
import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/model/producto_model.dart';

abstract class CatalogEvent {}

class AddCatalogItemEvent extends CatalogEvent {
  final ProductoModel item;

  AddCatalogItemEvent(this.item);
}

class RemoveCatalogItemEvent extends CatalogEvent {
  final ProductoModel item;

  RemoveCatalogItemEvent(this.item);
}

class EditCatalogItemEvent extends CatalogEvent {
  final ProductoModel item;

  EditCatalogItemEvent(this.item);
}

class GetCatalogEvent extends CatalogEvent {
  
}
