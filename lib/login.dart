
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'constant.dart';
//import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'register.dart';
import 'home.dart';
import 'package:flutter_http_request/coupon/coupon_list.dart';

import 'package:flutter_http_request/personal_info/base_provider.dart';
import 'personal_info/change_personal_info_bloc.dart';
import 'personal_info/personal_info_api.dart';
import 'personal_info/mine_page.dart';
import 'test_home.dart';

class LoginScreen extends StatefulWidget {
  String _account, _password;

  @override
  _LoginScreenState createState() => new _LoginScreenState();

  LoginScreen(this._account, this._password);
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  Color _eyeColor;
  List _loginMethod = [
    {
      "title": "facebook",
   //   "icon": GroovinMaterialIcons.facebook,
    },
    {
      "title": "google",
    //  "icon": GroovinMaterialIcons.google,
    },
    {
      "title": "twitter",
    //  "icon": GroovinMaterialIcons.twitter,
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("登录"),
      ),
        body: GestureDetector(
            onTap: ()=> FocusScope.of(context).requestFocus(FocusNode()),//隐藏键盘
            child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(height: 50),
                buildTitle(),
                buildTitleLine(),
                SizedBox(height: 70.0),
                buildAccountTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                buildRegisterText(context),
              ],
            ))),);
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context){
                      return RegisterScreen(isRegister: true,);
                    }));
              },
            ),
          ],
        ),
      ),
    );
  }

  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(
                builder: (context) {
                  return IconButton(
                      icon: Icon(item['icon'],
                          color: Theme.of(context).iconTheme.color),
                      onPressed: () {
                        //TODO : 第三方登录方法
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("${item['title']}登录"),
                          action: new SnackBarAction(
                            label: "取消",
                            onPressed: () {},
                          ),
                        ));
                      });
                },
              ))
          .toList(),
    );
  }

  Align buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          '其他账号登录',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '登录',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.blue[400],
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              _login();
            }
          },
          shape: const RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }

  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            '忘记密码',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context){
                  return new RegisterScreen(isRegister: false,);
                }));
          },
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => widget._password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      initialValue: widget._password,
      decoration: InputDecoration(
          labelText: '密码',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildAccountTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '手机号:',
      ),
      validator: (String value) {
        var emailReg = RegExp(
            "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}\$");
        if (!emailReg.hasMatch(value)) {
          return '请输入正确的手机号码';
        }
      },
      initialValue: widget._account,
      onSaved: (String value) => widget._account = value,
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            '登录',
            style: TextStyle(fontSize: 42.0),
          ),
        ));
  }

  Future _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(widget._account.isEmpty || widget._password.isEmpty){
      setState(() {
        showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                  content: Text("用户名和密码不能为空"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("确定"),
                    )]
              );
            });
      });
    }

    FormData formData = new FormData.from({
      "phone": widget._account,
      "captcha": widget._password,
    });
    Options option = Options(
        contentType: ContentType.parse("application/x-www-form-urlencoded"));
    Dio dio = new Dio(option);
    Response response = await dio.post(
        "http://115.159.93.175:8281/repairs/login",
        data: {"phone": widget._account, "captcha": widget._password});
    if (response.statusCode == 200) {
      _formKey.currentState.reset();
//      Result<User> result = Result.fromJso15837n(response.data);
      prefs.setString("token", response.data["token"]);
      prefs.setString("account", widget._account);
//      prefs.setString("password", widget._password);
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          /*builder: (context){
            return BlocProvider<ChangePersonalInfoBloc>(
              onDispose: (context,bloc)=>bloc.dispose(),
              builder:(context,bloc)=>bloc??ChangePersonalInfoBloc(PersonalInfoApi()),
              child: MinePage(),
            );
          }*/
          builder: (context){
            return TestHome();
          }
          ));
      /*Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
              builder: (context){
                return new CouponList(token:response.data["token"],);
              }));*/
      }
    }
    //todo:put this logic inside above, otherwise it will go to home page anyway

}
