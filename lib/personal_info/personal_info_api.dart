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

  int _oneDayMilliSeconds = 86400;
  Future<RepairUserDB> getPersonalInfo() async {
    RepairUserDB repairUserDB;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    //var map = getPersonalInfoFromDB(token);
    var map = await getPersonalInfoFromDB(token);
    if (map == null) {
      var value = await getPersonalInfoFromInternet(token,false);
      return value;
    } else {
      repairUserDB = RepairUserDB.fromMap(map);
      if((new DateTime.now().millisecond - repairUserDB.time)>= _oneDayMilliSeconds){
        var value = await getPersonalInfoFromInternet(token,true);
        return value;
      }
      return repairUserDB;
    }

  }

  Future<RepairUserDB> getPersonalInfoFromInternet(String token,bool updateDB) async{
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
        "headimg":repairsUser.headimg,
        'time':new DateTime.now().millisecond
      };
      //insert or update the repairuser in DB
      repairUserDB = RepairUserDB.fromMap(map);
      //Map dbResult = await getPersonalInfoFromDB(token);
      if(!updateDB){
        await insertNewPersonalInfoIntoDB(token, repairsUser.name, repairsUser.headimg);
      }else{
        await updatePersonalInfoOnDb(map, token);
      }
      return repairUserDB;
    }else{
      print("error of fecthing info from internet. msg: ${resultModel.data}");
      //repairUserDB = RepairUserDB(id: "unknown",name:"用户姓名",headimg:"assets/images/person_placeholder.png");
      return null;
    }

  }

  //update name
  void updateName(String id, String newName)async{
    var msg = await updateNameOnInternet(id, newName);
    print("update name: "+ msg);
    if(msg=="修改成功"){
      var result = await updateNameOnDB(id, newName);
      if(result>=0){
        //RepairUserDB repairUserDB = RepairUserDB(id: id,name: name,headimg: file.path,time:new DateTime.now().millisecond );
        //return repairUserDB;
        Fluttertoast.showToast(msg: "昵称更新成功");
      }
    }else{
      //todo:更新失败
    }

  }

  Future<String> updateNameOnInternet(String id,String newName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    Options options = new Options();
    options.headers = {"token": token};
    print("update name url: "+ HttpAddressManager().getUpdatePersonalInfoUrl());
    try {
      Response response = await Dio().post(
          HttpAddressManager().getUpdatePersonalInfoUrl(),
          options: options,
          data: {
            'id':id,
            'name':newName
          });
      print("update name: "+response.toString());
      /*
    {"msg":"运行异常，请联系管理员","code":500,"state":false}
     */
      String msg = json.decode(response.data.toString()).cast<String, dynamic>()['msg'];
      Fluttertoast.showToast(msg: msg);
      return msg;
      //todo: handle response to decide if the name is updated successfully
    } catch (e) {
      print(e);
    }
  }

  Future<int> updateNameOnDB(String id,String name)async{
    Database database = await getDB();
    Batch batch = database.batch();
    batch.update(tableName, {columnName:name},where: "$columnId=?", whereArgs: [id]);
    var results = await batch.commit();
    await database.close();
    return results[0];
  }


  //update image

  Future<bool> updateImage(File file,String id)async{
    var msg = await updateImageOnInternet(file, id);
    if(msg=="修改成功"){
      var result = await updateImgOnDB(id, file.path);
      if(result>=0){
        //RepairUserDB repairUserDB = RepairUserDB(id: id,name: name,headimg: file.path,time:new DateTime.now().millisecond );
        //return repairUserDB;
        Fluttertoast.showToast(msg: "头像更新成功");
        return true;
      }
    }else{
      //todo: if msg is "修改失败"
      return false;
    }
  }

  /*
  Future<int> updateImageOnDB(File file,String id,String name)async{
    var map = await getPersonalInfoFromDB(id);
    int result;
    if(map==null){
      result = await insertNewPersonalInfoIntoDB(id, name, file.path);
    }else{
      result = await updateImgOnDB(id,file.path);
    }
    return result;
  }*/

  Future<int> updateImgOnDB(String id,String headimg)async{
    Database database = await getDB();
    Batch batch = database.batch();
    batch.update(tableName, {columnHeadImg:headimg},where: "$columnId=?", whereArgs: [id]);
    var results = await batch.commit();

    /*var valueToUpdate = <String,dynamic>{
      columnId:id,
      columnName:name,
      columnHeadImg:headimg,
      columnTime:new DateTime.now().millisecond
    };
    var returnedId = await database.update(
        tableName,
        valueToUpdate,
        where: "$columnId=?",
        whereArgs: [id]
    );*/
    await database.close();
    return results[0];
  }


  Future<String> updateImageOnInternet(File file,String id)async {
    Dio dio = new Dio();
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(file, file.path),
    });
    print("update image url: "+ HttpAddressManager().getUpdatePersonalInfoUrl());
    Response response = await dio.post(
      HttpAddressManager().getUploadImgUrl(),
      data: formData,
    );
    print("upload image to server: "+response.toString());

    /*
    {"msg":"success","code":0,"data":{"fileName":"image_cropper_1560094980476.jpg","url":"/uploadFile/img/image_cropper_156009498047
     */

    if(json.decode(response.toString()).cast<String, dynamic>()['msg']=="success"){
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token");
      RequestManager.baseHeaders = {"token": token};
      ResultModel resultModel = await RequestManager.requestPost(
          HttpAddressManager().updatePersonalInfo,
          {"id": id, "headimg": json.decode(response.toString())['data']['url']});
      //todo
      /*
    {"msg":"运行异常，请联系管理员","code":500,"state":false}
     */
      print("update personal info: "+resultModel.data.toString());
      String msg = json.decode(resultModel.data.toString()).cast<String, dynamic>()['msg'];
      Fluttertoast.showToast(msg: msg);
      return msg;
    }else{
      Fluttertoast.showToast(msg: json.decode(response.toString()).cast<String, dynamic>()['msg']);
    }
  }


//todo: CRUD
  final String dbName = 'personal_info.db';
  final String tableName = "my_personal_info";
  final String columnId = "id";
  final String columnName = "name";
  final String columnHeadImg = "headimg";
  final String columnTime = "time";

  Future<Database> getDB()async{
    var databasePath = await getDatabasesPath();
    String path = join(databasePath,dbName);
    var database = await openDatabase(
        path,
        version: 1,
        onCreate: (db,version)async{
          return db.execute(
              "CREATE TABLE $tableName($columnId STRING PRIMARY KEY, $columnName TEXT,$columnHeadImg String,$columnTime INTEGER)"
          );
        }
    );
    return database;
  }
  //todo:personal info
  //query database
  Future<Map<String,dynamic>> getPersonalInfoFromDB(String id) async{
    Database database = await getDB();
    List<Map<String, dynamic>> list = await database.query(
      tableName,
      columns: [columnId,columnName,columnHeadImg,columnTime],
      where: "$columnId=?",
      whereArgs: [id]
    );
    await database.close();
    if(list.isEmpty){
      return null;
    }
    return list.first;
  }


  //insert into database
  Future<int> insertNewPersonalInfoIntoDB(String id, String name, String headimg)async{
    Database database = await getDB();
    var valueToInsert = <String,dynamic>{
      columnId:id,
      columnName:name,
      columnHeadImg:headimg,
      columnTime:new DateTime.now().millisecond
    };
    var returnedId = await database.insert(tableName, valueToInsert);
    await database.close();
    return returnedId;
  }

  Future<int> updatePersonalInfoOnDb(Map map,String token)async{
    Database database = await getDB();
    int result = await database.update(tableName, map, where: "$columnId=?", whereArgs: [token]);
    await database.close();
    return result;
  }

  //delete in database

  Future<int> deletePersonalInfoFromDB(String id) async{
    Database database = await getDB();
    var returnedId = await database.delete(
        tableName,
        where: "$columnId=?",
        whereArgs: [id]
    );
    await database.close();
    return returnedId;
  }



}