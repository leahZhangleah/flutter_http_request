
import 'dart:async';

class ChangeUsernameBloc{
  //String userName;
  StreamController<String> _userNameController;
  StreamSink<String> get input => _userNameController.sink;
  Stream<String> get output => _userNameController.stream;

  ChangeUsernameBloc(){
    _userNameController = StreamController<String>();
  }

  void dispose(){
    _userNameController.close();
  }
}