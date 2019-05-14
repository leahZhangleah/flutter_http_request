
import 'dart:async';
import 'repairuser_db.dart';
import 'personal_info_api.dart';
import 'base_provider.dart';
import 'dart:io';


class ChangePersonalInfoBloc{
  final PersonalInfoApi personalInfoApi;
  //String userName;
  StreamController<RepairUserDB> _repairsUserController;
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
    var msg = await uploadImageToInternet(file, id);
    if(msg=="修改成功"){
      await uploadImageToDB(file, id, name);
      RepairUserDB repairUserDB = RepairUserDB(id: id,name: name,headimg: file.path);
      _repairsUserController.sink.add(repairUserDB);
    }
  }

  Future<void> uploadImageToDB(File file,String id,String name)async{
    var map = await personalInfoApi.getPersonalInfoFromDB(id);
    if(map==null){
      await personalInfoApi.insertNewPersonalInfoIntoDB(id, name, file.path);
    }else{
      await personalInfoApi.updateImgInDB(id, name, file.path);
    }
  }

  Future<String> uploadImageToInternet(File file,String id)async{
    return await personalInfoApi.uploadImageToInternet(file, id);
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