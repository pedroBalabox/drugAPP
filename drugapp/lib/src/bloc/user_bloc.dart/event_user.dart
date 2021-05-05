
import 'package:drugapp/model/user_model.dart';

abstract class UserEvent {}

class AddUserItemEvent extends UserEvent {
  final UserModel user;

  AddUserItemEvent(this.user);
}

class RemoveUserItemEvent extends UserEvent {
  final UserModel user;

  RemoveUserItemEvent(this.user);
}

class EditUserItemEvent extends UserEvent {
  final UserModel user;

  EditUserItemEvent(this.user);
}

class GetUserEvent extends UserEvent {}
