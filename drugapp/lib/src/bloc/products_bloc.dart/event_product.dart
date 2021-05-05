
import 'package:drugapp/model/producto_model.dart';

abstract class CatalogEvent {}

class AddCatalogItemEvent extends CatalogEvent {
  final ProductModel item;

  AddCatalogItemEvent(this.item);
}

class RemoveCatalogItemEvent extends CatalogEvent {
  final ProductModel item;

  RemoveCatalogItemEvent(this.item);
}

class EditCatalogItemEvent extends CatalogEvent {
  final ProductModel item;

  EditCatalogItemEvent(this.item);
}

class GetCatalogEvent extends CatalogEvent {}
