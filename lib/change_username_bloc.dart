
import 'dart:async';

class ChangeUsernameBloc{
  String userName;
  final _userNameController = StreamController<String>();
  StreamSink<String> get input => _userNameController.sink;
  Stream<String> get output => _userNameController.stream;

  ChangeUsernameBloc(){
    output.listen((input){
      userName = input;
    });
  }

  void dispose(){
    _userNameController.close();
  }
}