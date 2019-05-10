import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_http_request/HttpUtils.dart';
import 'dart:convert';
import 'repair_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'repairuser_db.dart';
class PersonalInfoApi {
  Future<RepairUserDB> getPersonalInfo() async {
    RepairUserDB repairUserDB;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    if(getPersonalInfoFromDB(token)!=null){
      getPersonalInfoFromDB(token).then((map){
        repairUserDB = RepairUserDB.fromMap(map);
        return repairUserDB;
      });
    }
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        "/maintainer/maintainerUser/personalInfo", null); //todo
    print(response.data.toString());
    RepairsUser repairsUser = jsonDecode(response.data.toString())
        .repairsUser;
    repairUserDB.id = token;
    repairUserDB.name = repairsUser.name;
    repairUserDB.headimg = repairsUser.headimg;
    /*String name = json
        .decode(response.data.toString())
        .cast<String, dynamic>()['repairsUser']['name'];*/
    //_repairsUserController.sink.add(repairsUser);
    return repairUserDB;
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
    if(list.length > 0){
      return list.first;
    }
    return null;
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