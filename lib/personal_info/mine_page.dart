import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_http_request/HttpUtils.dart';
import 'package:flutter_http_request/personal_info/personal.dart';
import 'package:flutter_http_request/register.dart';
import 'package:flutter_http_request/behavior.dart';
import 'package:flutter_http_request/personal_info/personalmodel.dart';
import 'package:flutter_http_request/personal_info/personal_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'change_personal_info_bloc.dart';
import 'repairuser_db.dart';
import 'base_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_http_request/http_address_manager.dart';
class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MineState();
  }
}

class MineState extends State<MinePage> {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  num padingHorzation = 20;
  Size deviceSize;
  //String name, image = "";
  //var getInfo;
  RepairUserDB repairUserDB;
  ChangePersonalInfoBloc changePersonalInfoBloc;

  @override
  void initState() {
    super.initState();
    //getInfo = getPersonalInfo();

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    changePersonalInfoBloc = Provider.of<ChangePersonalInfoBloc>(context);
    changePersonalInfoBloc.getPersonalInfo();

  }


  @override
  Widget build(BuildContext context) {
    PersonalViewMModel vm = PersonalViewMModel();
    List<PersonalModel> data = vm.getPersonalItems();
    deviceSize = MediaQuery.of(context).size;
    padingHorzation = deviceSize.width / 4;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.lightBlue,
        ),
        bottom: PreferredSize(
            child: Container(
              height: 100,
              child: StreamBuilder(
                  stream: changePersonalInfoBloc.repairUserDB,
                  builder: (context,AsyncSnapshot<RepairUserDB> snapshot){
                    if(snapshot.hasData){
                      repairUserDB = snapshot.data;
                      return buildPersonalLine(repairUserDB);
                    }else if(snapshot.hasError){
                      return _buildErrorWidget(snapshot.error);
                    }else{
                      return _buildLoadingWidget();
                    }
                  }),
            ),
            preferredSize: Size(30, 80)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
//                      buildPersonalLine(), //第一行
                ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildAddressLine(index, data);
                        }))
              ],
            ),
          ),
          /*Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Copyright©2019-2029\n上海允宜实业发展有限公司",
                textAlign: TextAlign.center,
              ),
            ),
          )*/
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          child: RaisedButton(
            onPressed: logOutDialog,
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

  void logOutDialog(){
    showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text("确认退出登录？"),
          actions: <Widget>[
            CupertinoDialogAction(
                onPressed: logout,
                child: Text("确认")),
            CupertinoDialogAction(
                onPressed: ()=>Navigator.pop(context),
                child: Text("取消")),
          ],
        );
      },
    );
  }

  void logout() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders={"token": token};
    ResultModel response = await RequestManager.requestPost(HttpAddressManager().logout,null);
    if(json.decode(response.data.toString())["msg"]=="success"||json.decode(response.data.toString())["msg"]=="token失效，请重新登录"){
      sp.remove("token");
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new RegisterScreen()
          ),(route)=>route==null );
    };
  }

  Widget buildPersonalLine(RepairUserDB repairUserDB) {
    if(repairUserDB==null){
      return new Text("无法获取用户信息");
    }
    return new Container(
        color: Colors.lightBlue,
        padding: EdgeInsets.only(left: 10, bottom: 10),
        height: 100,
        child: Center(
          child: ListTile(
            leading: ClipOval(
              child: buildImgWidget(repairUserDB.headimg),
            ),
            title: Text(
              repairUserDB.name,
              style: TextStyle(
                  letterSpacing: 5, fontSize: 20, color: Colors.white),
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 40,
            ),
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (c) {
                    return Personal(); //todo go to personal setting page //repairUserDB: repairUserDB,
                  },
                ),
              )
                  /*.then((_) {
                getPersonalInfo();
              })*/;
            },
          ),
        ));
  }

  Widget  buildImgWidget(String imgUrl){
    if(imgUrl.startsWith("assets")){
      return Image.asset(imgUrl);
    }else if(imgUrl.startsWith("/upload")){
      String fileUploadServer = HttpAddressManager().fileUploadServer;
      String networkImgUrl = fileUploadServer+imgUrl;
      CachedNetworkImage cachedNetworkImage = CachedNetworkImage(
          imageUrl: networkImgUrl,
          placeholder: (context,url)=>new CircularProgressIndicator(),
        errorWidget: (context,url,error)=>new Icon(Icons.error),
      );
      //updateImgPathInDB(networkImgUrl,cachedNetworkImage.cacheManager);
      return cachedNetworkImage;
    }else{//todo: if the data is from DB, and the image path is from cache, it could be GCed and invalid, make judgement here to decide if it's from cache or from file
      //return Image.asset(imgUrl);
      return Image.file(new File(imgUrl));
    }
  }

  /*
  Future<void> updateImgPathInDB(String imgUrl,BaseCacheManager cacheManager) async {
    var fileInfo = await cacheManager.getFileFromCache(imgUrl);
    print("the returned local image address of "+imgUrl+" is: "+fileInfo.file.path);
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    await changePersonalInfoBloc.insertPersonalInfoInDB(token, repairUserDB.name,fileInfo.file.path); //todo, problem: has never been updated to db
  }*/

  Widget buildAddressLine(index, datas) {
    PersonalModel model = datas[index];
    return Container(
        color: Colors.white,
        height: 60,
        child: Column(children: <Widget>[
          Center(
            child: ListTile(
              leading: Icon(model.leadingIcon),
              title: Text(model.text),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey[400],
              ),
              onTap: () {
                index == 0
                    ? Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return null;//todo navigate to 我的订单
                    },
                  ),
                )
                    : index == 1
                    ? Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return null;//todo navigate to 收到评价
                    },
                  ),
                ): Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return null;//TODO navigate to 认证信息
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            child: Divider(height: 3, color: Colors.grey[300]),
            margin: EdgeInsets.only(left: 15, right: 15),
          )
        ]));
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




}