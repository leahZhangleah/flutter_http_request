import 'dart:async';

import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'package:flutter_http_request/personal_info/personal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_http_request/personal_info/change_personal_info_bloc.dart';
import 'package:flutter_http_request/coupon/coupon_list.dart';
import 'package:flutter_http_request/personal_info/base_provider.dart';
import 'personal_info/change_personal_info_bloc.dart';
import 'personal_info/personal_info_api.dart';
import 'personal_info/mine_page.dart';
String token;
void main()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //sharedPreferences.clear();
  token = sharedPreferences.get("token");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (context){
          return BlocProvider<ChangePersonalInfoBloc>(
            onDispose: (context,bloc)=>bloc.dispose(),
            builder: (context,bloc)=>bloc??ChangePersonalInfoBloc(PersonalInfoApi()),
            child: MinePage(),
          );
        }));
    /*if(token==null){
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
              builder: (context){
                return new LoginScreen(null, null);
              }));
    }else{
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
              builder: (context){
                return new CouponList(token: token,);
              })
      );
    }*/
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: new Image.asset(
                  'assets/images/logo.png',
                  height: 25.0,
                  fit: BoxFit.scaleDown,
                ),
              )
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}























