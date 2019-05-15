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

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PersonalState();
  }
}

class PersonalState extends State<Personal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  num padingHorzation = 20.0;
  //String imageurl = "assets/images/person_placeholder.png";
  //var getInfo;
  bool isVideo = false;
  Future<File> _imageFile;
  ChangePersonalInfoBloc personalInfoBloc;
  RepairUserDB currentRepairUserDB;

  void initState(){
    super.initState();
    //getInfo =  getPersonalInfo();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    personalInfoBloc = Provider.of<ChangePersonalInfoBloc>(context);
  }
  
  void _onImageButtonPressed(ImageSource source) async{
    setState(() {
      if (isVideo) {
        return;
      } else {
        _imageFile = ImagePicker.pickImage(source: source).then((file){
          if(source == ImageSource.camera){
            print("the photo path from camera is: ${file.path}");
          }else{
            print("the photo path from gallery is: ${file.path}");
          }
          updatePersonHeading(file);
         /* // uploadHeadimg();
          imageurl = file.toString();
          print("the returned image file address: "+imageurl);
          updatePersonHeading();*/
        });
      }
    });
  }

  Future updatePersonHeading(File file) async{
    Navigator.push<String>(
        context,new MaterialPageRoute(
        builder: (BuildContext context){
          if(currentRepairUserDB!=null){
            return new Imagecut(imgFile:file,id:currentRepairUserDB.id,name: currentRepairUserDB.name,);
          }else{
            Fluttertoast.showToast(msg: "id为空，无法更新头像");
            return null;
          }
    }));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("设置"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
      ),
      body: StreamBuilder(
          stream: personalInfoBloc.repairUserDB,
          builder: (context,AsyncSnapshot<RepairUserDB> snapshot){
            if(snapshot.hasData){
              currentRepairUserDB = snapshot.data;
              return _buildPersonalLine(snapshot);
            }else if(snapshot.hasError){
              return _buildErrorWidget(snapshot.error);
            }else{
              return _buildLoadingWidget();
            }
          }),
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

  Widget _buildPersonalLine(AsyncSnapshot<RepairUserDB> snapshot) {
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
                        }),
                    child: ClipOval(
                      child: Image.file(new File(snapshot.data.headimg),width: 75.0,height: 75.0,),
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
