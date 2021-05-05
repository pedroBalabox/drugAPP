import 'dart:async';

import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/event_user.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/state_user.dart';

class UserBloc {
  UserState _userState = UserState();

  StreamController<UserEvent> _input = StreamController();
  StreamController<UserModel> _output =
      StreamController<UserModel>.broadcast();

  StreamSink<UserEvent> get sendEvent => _input.sink;
  Stream<UserModel> get catalogStream => _output.stream;

  UserBloc() {
    _input.stream.listen(_onEvent);
  }

  void _onEvent(UserEvent event) {
    if (event is AddUserItemEvent) {
      _userState.addToUser(event.user);
    } else if (event is RemoveUserItemEvent) {
      _userState.removeFromUser(event.user);
    } 
    else if (event is EditUserItemEvent) {
      _userState.editToUser(event.user);
    }

    _output.add(_userState.catalog);
  }

  void dispose() {
    _input.close();
    _output.close();
  }
}
