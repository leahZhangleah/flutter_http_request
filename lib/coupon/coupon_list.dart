import 'package:flutter/material.dart';
import 'titlebar.dart';
//import 'coupon.dart';
import 'coupon_description.dart';
import 'HttpUtils.dart';
import 'dart:convert';
import 'coupon_response.dart';
import 'coupon.dart';
import 'package:flutter_http_request/login.dart';
class CouponList extends StatefulWidget{
  String token;
  CouponList({this.token});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CouponListState();
  }

}

class CouponListState extends State<CouponList> {
  String token;
  List<CouponDescription> couponList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    couponList = new List();
    token = widget.token;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(child: Titlebar1(
          titleValue: "优惠券",
          leadingCallback: ()=>Navigator.pop(context),),
          preferredSize: Size.fromHeight(50)),
      body: Container(
        child: FutureBuilder(
          future: _fetchCouponList(token),
            builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              if(snapshot.hasData){
                couponList.clear();
                couponList = snapshot.data;
                return ListView.builder(
                    itemCount: couponList.length,
                    itemBuilder: (context,index){
                      return Coupon(couponDescription: couponList[index],);
                    });
              }else{
                //todo: the data fetched from internet is null
                return new Container();
              }
            }else if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }else if(snapshot.connectionState == ConnectionState.none){
              //todo: show a toast
              return Text("请检查网络");
            }
            }),
      )
    );
  }

  Future<List<CouponDescription>> _fetchCouponList(String token)async{
    //todo: figure out parameters needed for coupon list request
    RequestManager.baseHeaders = {"token":token};
    String couponListUrl = "/repairs/couponUser/myUsableCoupon";

    ResultModel response = await RequestManager.requestGet(couponListUrl, null);
    var json = jsonDecode(response.data.toString());
    if(json["msg"]=="token失效，请重新登录"){
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
          builder: (context){
            return new RegisterScreen();
          }));
    }
    return CouponResponse.fromJson(json).couponList;
   /* if(CouponResponse.fromJson(json).state){

    }else{
      print(CouponResponse.fromJson(json).msg);
      return new List();
    }*/
    /*if(response.data!=null){

    }else{
      return new List();
    }*/
  }
}