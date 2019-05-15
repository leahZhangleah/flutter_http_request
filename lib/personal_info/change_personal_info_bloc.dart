
import 'dart:async';
import 'repairuser_db.dart';
import 'personal_info_api.dart';
import 'dart:io';
import 'package:rxdart/rxdart.dart';


class ChangePersonalInfoBloc{
  final PersonalInfoApi personalInfoApi;
  //String userName;
  BehaviorSubject<RepairUserDB> _repairsUserController;
  Stream<RepairUserDB> get repairUserDB => _repairsUserController.stream;
  //Stream<String> get image => _imageController.stream;

  ChangePersonalInfoBloc(this.personalInfoApi){
    _repairsUserController = StreamController.broadcast();
    
  }

  Future<void> getPersonalInfo() async {
    RepairUserDB repairUserDB = await personalInfoApi.getPersonalInfo();
    _repairsUserController.sink.add(repairUserDB);
    /*await personalInfoApi.getPersonalInfo().then((value){

    });*/
  }

  Future<void> uploadImage(File file,String id,String name)async{
    var repairUserDb = await personalInfoApi.uploadImage(file, id, name);
    if(repairUserDb!=null){
      _repairsUserController.sink.add(repairUserDb);
    }else{
      await getPersonalInfo();
    }
  }


  Future<void> insertPersonalInfoInDB(String id,String name, String headimg)async{
    var result = await personalInfoApi.insertNewPersonalInfoIntoDB(id, name,headimg);
    print("the returned updated id is: "+String.fromCharCode(result));
    if(result >=0){
      await getPersonalInfo();
    }

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