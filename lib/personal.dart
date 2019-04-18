import 'dart:convert';
import 'package:flutter/material.dart';
import 'Name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'change_username_bloc.dart';
import 'username_provider.dart';
class Personal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PersonalState();
  }
}

class PersonalState extends State<Personal> {
  num padingHorzation = 20.0;
  String defaultName = "用户姓名";
  ChangeUsernameBloc _bloc;
  SharedPreferences _sharedPreferences;
  String key="userName";
  String name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_bloc = new ChangeUsernameBloc();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    name = _sharedPreferences.get(key)??defaultName;
  }
  //String _res = "";
  @override
  Widget build(BuildContext context) {
    _bloc = UsernameProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
    centerTitle: true,
    leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
    ),
      body: Container(
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
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                ),
                                new ListTile(
                                  leading: new Icon(Icons.photo_library),
                                  title: new Text("手机相册上传"),
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          }),
                      child: ClipOval(
                        child: new FadeInImage.assetNetwork(
                          placeholder: "assets/images/logo.png",
                          image: "assets/images/logo.png",
                          width: 60.0,
                          height: 60.0,
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
                  padding: EdgeInsets.fromLTRB(15, 15, 20, 25),
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
                              return new Name();
                          })
                          ),
                          child: Container(
                            child: StreamBuilder(
                                initialData: name,
                                stream: _bloc.output,
                                builder: (context,snapshot){
                                  if(snapshot.connectionState==ConnectionState.done){
                                    if(snapshot.data!=null){
                                      return Text(snapshot.data);
                                    }else{
                                      return Text(name);
                                    }
                                  }

                                }),
                          )
                          /*_res==""?
                          Text("$name", style: TextStyle(fontSize: 20),):
                          Text("$_res",style: TextStyle(fontSize: 20),)*/
                          )
                    ],
                  ),
                ))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80.0,
          child: RaisedButton(
            onPressed: (){},
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

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }


  /*void logout() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders={"token": token};
    ResultModel response = await RequestManager.requestPost("/maintainer/logout",null);
    if(json.decode(response.data.toString())["msg"]=="success"){
      print(222);
      sp.remove("token");
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new RegisterScreen()
          ), (route) => route == null);
    };
  }*/
}
