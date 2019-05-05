
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_http_request/HttpUtils.dart';
import 'dart:convert';
import 'personal_info_response.dart';
import 'repair_user.dart';

class ChangePersonalInfoBloc{
  //String userName;
  StreamController<RepairsUser> _repairsUserController;
  Stream<RepairsUser> get repairsUser => _repairsUserController.stream;
  //Stream<String> get image => _imageController.stream;

  ChangeUsernameBloc(){
    _repairsUserController = StreamController<RepairsUser>();
    //_imageController = StreamController<String>();
    getPersonalInfo();
  }

  void dispose(){
    _repairsUserController.close();
    //_imageController.close();
  }

  Future getPersonalInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    try{
      ResultModel response = await RequestManager.requestGet(
          "/maintainer/maintainerUser/personalInfo", null);//todo
      print(response.data.toString());
      RepairsUser repairsUser = jsonDecode(response.data.toString()).repairsUser;
      /*String name = json
        .decode(response.data.toString())
        .cast<String, dynamic>()['repairsUser']['name'];*/
      _repairsUserController.sink.add(repairsUser);
    }catch(error,stacktrace){
      print("Exception occured: $error stacktrace: $stacktrace");
    }

    /*String image = json
        .decode(response.data.toString())
        .cast<String, dynamic>()['repairsUser']['headimg'];
    if(image==null){
      image = "assets/images/person_placeholder.png";
    }
    _imageController.sink.add(image);*/
  }
}