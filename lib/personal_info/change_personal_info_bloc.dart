
import 'dart:async';
import 'repairuser_db.dart';
import 'personal_info_api.dart';


class ChangePersonalInfoBloc{
  final PersonalInfoApi personalInfoApi;
  //String userName;
  StreamController<RepairUserDB> _repairsUserController;
  Stream<RepairUserDB> get repairUserDB => _repairsUserController.stream;
  //Stream<String> get image => _imageController.stream;

  ChangePersonalInfoBloc(this.personalInfoApi){
    _repairsUserController = StreamController<RepairUserDB>();
    personalInfoApi.getPersonalInfo().then((value){
      _repairsUserController.sink.add(value);
    });
    //_imageController = StreamController<String>();
    
  }

  Future<void> updatePersonalInfoInDB(String id,String name, String headimg)async{
    return await personalInfoApi.updateImgInDB(id, name,headimg).then((result){
      print("the returned updated id is: "+String.fromCharCode(result));
      if(result >=0){
        RepairUserDB repairUserDB = RepairUserDB(id: id,name: name,headimg: headimg);
        _repairsUserController.sink.add(repairUserDB);
      }
    });
  }

  void dispose(){
    _repairsUserController.close();
    //_imageController.close();
  }



    /*String image = json
        .decode(response.data.toString())
        .cast<String, dynamic>()['repairsUser']['headimg'];
    if(image==null){
      image = "assets/images/person_placeholder.png";
    }
    _imageController.sink.add(image);*/
}