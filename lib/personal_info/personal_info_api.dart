import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_http_request/HttpUtils.dart';
import 'dart:convert';
import 'repair_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'repairuser_db.dart';
import 'personal_info_response.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_http_request/http_address_manager.dart';
class PersonalInfoApi {
  Future<RepairUserDB> getPersonalInfo() async {
    RepairUserDB repairUserDB;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    //var map = getPersonalInfoFromDB(token);
    var map = await getPersonalInfoFromDB(token);
    if (map == null) {
      var value = await getPersonalInfoFromInternet(token);
      return value;
    } else {
      repairUserDB = RepairUserDB.fromMap(map);
      return repairUserDB;
    }
    //var map = await getPersonalInfoFromDB(token);


    /*String name = json
        .decode(response.data.toString())
        .cast<String, dynamic>()['repairsUser']['name'];*/
    //_repairsUserController.sink.add(repairsUser);

  }

  Future<RepairUserDB> getPersonalInfoFromInternet(String token) async{
    RepairUserDB repairUserDB;
    RequestManager.baseHeaders = {"token": token};
    ResultModel resultModel = await RequestManager.requestGet(
        HttpAddressManager().personalInfo, null); //todo
    print(resultModel.data.toString());
    if(resultModel.success){
      RepairsUser repairsUser =PersonalInfoResponse.fromJson(jsonDecode(resultModel.data.toString())).repairsUser;
      if(repairsUser.headimg==null){
        repairsUser.headimg = "assets/images/person_placeholder.png";
      }
      if(repairsUser.name==null){
        repairsUser.name = "用户姓名";
      }
      Map<String,dynamic> map = {
        "id":repairsUser.id,
        "name":repairsUser.name,
        "headimg":repairsUser.headimg
      };
      repairUserDB = RepairUserDB.fromMap(map);
      return repairUserDB;
    }else{
      print("error of fecthing info from internet. msg: ${resultModel.data}");
      repairUserDB = RepairUserDB(id: "unknown",name:"用户姓名",headimg:"assets/images/person_placeholder.png");
      return repairUserDB;
    }

    /*repairUserDB.id = token;
    repairUserDB.name = repairsUser.name;
    repairUserDB.headimg = repairsUser.headimg;*/

  }

  Future<RepairUserDB> uploadImage(File file,String id,String name)async{
    var msg = await uploadImageToInternet(file, id);
    if(msg=="修改成功"){
      var result = await uploadImageToDB(file, id, name);
      if(result>=0){
        RepairUserDB repairUserDB = RepairUserDB(id: id,name: name,headimg: file.path);
        return repairUserDB;
      }else{
        return null;
      }
    }
  }

  Future<int> uploadImageToDB(File file,String id,String name)async{
    var map = await getPersonalInfoFromDB(id);
    int result;
    if(map==null){
      result = await insertNewPersonalInfoIntoDB(id, name, file.path);
    }else{
      result = await updateImgInDB(id, name, file.path);
    }
    return result;
  }

  Future<String> uploadImageToInternet(File file,String id)async {
    Dio dio = new Dio();
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(file, file.path),
    });

    Response response = await dio.post(
      HttpAddressManager().getUploadImgUrl(),
      data: formData,
    );
    print(response);

    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel resultModel = await RequestManager.requestPost(
       HttpAddressManager().updatePersonalInfo,
        {"id": id, "headimg": json.decode(response.toString())['data']['url']});
    print(resultModel.data);
    String msg = json.decode(resultModel.data.toString()).cast<String, dynamic>()['msg'];
    Fluttertoast.showToast(msg: msg);
    return msg;
  }


  Future<Database> getDB()async{
    var databasePath = await getDatabasesPath();
    String path = join(databasePath,dbName);
    var database = await openDatabase(
        path,
        version: 1,
        onCreate: (db,version)async{
          return db.execute(
              "CREATE TABLE $tableName($columnId STRING PRIMARY KEY, $columnName TEXT,$columnHeadImg String)"
          );
        }
    );
    return database;
  }

  Future<Map<String,dynamic>> getPersonalInfoFromDB(String id) async{
    Database database = await getDB();
    List<Map<String, dynamic>> list = await database.query(
      tableName,
      columns: [columnId,columnName,columnHeadImg],
      where: "$columnId=?",
      whereArgs: [id]
    );
    if(list.isEmpty){
      return null;
    }
    return list.first;
  }
  
  final String dbName = 'personal_info.db';
  final String tableName = "my_personal_info";
  final String columnId = "id";
  final String columnName = "name";
  final String columnHeadImg = "headimg";

  Future<int> insertNewPersonalInfoIntoDB(String id, String name, String headimg)async{
    Database database = await getDB();
    var valueToInsert = <String,dynamic>{
      columnId:id,
      columnName:name,
      columnHeadImg:headimg
    };
    var returnedId = await database.insert(tableName, valueToInsert);
    return returnedId;
  }

  Future<int> updateNameInDB(String id,String name,String headimg)async{
    Database database = await getDB();
    var valueToUpdate = <String,dynamic>{
      columnId:id,
      columnName:name,
      columnHeadImg:headimg,
    };
    var returnedId = await database.update(
        tableName,
        valueToUpdate,
        where: "$columnId=?",
        whereArgs: [id]
    );
    return returnedId;
  }

  Future<int> updateImgInDB(String id,String name,String headimg)async{
    Database database = await getDB();
    var valueToUpdate = <String,dynamic>{
      columnId:id,
      columnName:name,
      columnHeadImg:headimg,
    };
    var returnedId = await database.update(
        tableName,
        valueToUpdate,
        where: "$columnId=?",
        whereArgs: [id]
    );
    return returnedId;
  }

  Future<int> deletePersonalInfoFromDB(String id) async{
    Database database = await getDB();
    var returnedId = await database.delete(
        tableName,
        where: "$columnId=?",
        whereArgs: [id]
    );
    return returnedId;
  }

}