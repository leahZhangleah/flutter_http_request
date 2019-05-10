import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_http_request/HttpUtils.dart';
import 'package:flutter_http_request/personal_info/Name.dart';
import 'package:flutter_http_request/personal_info/imagecut.dart';
import 'package:flutter_http_request/register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'repairuser_db.dart';
import 'base_provider.dart';
import 'change_personal_info_bloc.dart';

class Personal extends StatefulWidget {
  //RepairUserDB repairUserDB;

  //Personal({this.repairUserDB});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PersonalState();
  }
}

class PersonalState extends State<Personal> {
  num padingHorzation = 20.0;
  String name,id,_res,url="";
  //String imageurl = "assets/images/person_placeholder.png";
  //var getInfo;
  bool isVideo = false;
  Future<File> _imageFile;

  void initState(){
    super.initState();
    //getInfo =  getPersonalInfo();
  }



  void _onImageButtonPressed(ImageSource source) async{
    setState(() {
      if (isVideo) {
        return;
      } else {
        /*_imageFile = ImagePicker.pickImage(source: source).then((file){
          // uploadHeadimg();
          imageurl = file.toString();
          print("the returned image file address: "+imageurl);
          updatePersonHeading();
        });*/
      }
    });
  }

  /*Future updatePersonHeading() async{
    print(imageurl);
    print(imageurl.substring(7,imageurl.length-1));
    imageurl = imageurl.substring(7,imageurl.length-1);
    Navigator.push<String>(
        context,new MaterialPageRoute(builder: (BuildContext context){
      return new Imagecut(imgurl:imageurl,id:id);
    })
    ).then((_){
      Navigator.pop(context);
    });
  }*/


  /*Future getPersonalInfo() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        "/repairs/repairsUser/personalInfo",null);
    print(response.data.toString());
    setState(() {
      name = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['repairsUser']['name'];
      id = json
          .decode(response.data.toString())
          .cast<String, dynamic>()['repairsUser']['id'];
      imageurl = json.decode(response.data.toString()).cast<String,dynamic>()['repairsUser']['headimg'];
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final personalInfoBloc = Provider.of<ChangePersonalInfoBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
      ),
      body: StreamBuilder(
          stream: personalInfoBloc.repairUserDB,
          builder: (context,AsyncSnapshot<RepairUserDB> snapshot){
            /*if(snapshot.data?.isEmpty??true){
                      return Center(
                        child: Text("Empty",style:Theme.of(context).textTheme.display1),
                      );
                    }
                    buildPersonalLine(context, snapshot);*/
            if(snapshot.hasData){
              return _buildFuture(snapshot);
            }else if(snapshot.hasError){
              return _buildErrorWidget(snapshot.error);
            }else{
              return _buildLoadingWidget();
            }
          }),
      /*FutureBuilder(
        builder: _buildFuture,
        future: getInfo, // 用户定义的需要异步执行的代码，类型为Future<String>或者null的变量或函数
      )*/
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80.0,
          child: RaisedButton(
            onPressed: logout,
            child: Text(
              "退出登录",
              style: TextStyle(fontSize: 20),
            ),
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildFuture(AsyncSnapshot<RepairUserDB> snapshot) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "头像",
                    style: TextStyle(color: Colors.grey[350], fontSize: 18),
                  ),
                  RaisedButton(
                    shape: CircleBorder(),
                    onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new ListTile(
                                  leading: new Icon(Icons.photo_camera),
                                  title: new Text("拍照"),
                                  onTap: ()=>_onImageButtonPressed(ImageSource.camera)
                              ),
                              new ListTile(
                                  leading: new Icon(Icons.photo_library),
                                  title: new Text("手机相册上传"),
                                  onTap: ()=>_onImageButtonPressed(ImageSource.gallery)
                              ),
                            ],
                          );
                        })/*.then((_){
                      getPersonalInfo();
                    })*/,
                    child: ClipOval(
                      child: Image.network(
                        snapshot.data.headimg, //todo: implement prioritization of image reading: database->internet
                        width: 75.0,
                        height: 75.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: Divider(
                height: 2,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
              height: 70,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "昵称",
                      style: TextStyle(color: Colors.grey[350], fontSize: 18),
                    ),
                    GestureDetector(
                        onTap: ()=>Navigator.push<String>(
                            context,new MaterialPageRoute(builder: (BuildContext context){
                          return new Name(name:snapshot.data.name,id:snapshot.data.id);
                        })
                        )
                        /*    .then((res){
                          _res=res;
                          name=_res;
                        })*/,
                        child: Text(snapshot.data.name, style: TextStyle(fontSize: 20),))
                  ],
                ),
              ))
        ],
      ),
    );
  }


  Widget _buildErrorWidget(error) {
    return Center(
      child:Text("错误：$error"),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('加载中...'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  void logout() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders={"token": token};
    ResultModel response = await RequestManager.requestPost("/maintainer/logout",null);
    if(json.decode(response.data.toString())["msg"]=="success"){
      sp.remove("token");
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new RegisterScreen()
          ), (route) => route == null);
    };
  }

}
