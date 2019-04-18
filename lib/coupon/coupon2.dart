import 'package:flutter/material.dart';
import 'coupon_response.dart';
import 'coupon_description.dart';

class Coupon extends StatefulWidget{
  CouponDescription couponDescription;
  Coupon({this.couponDescription});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CouponState();
  }

}

class CouponState extends State<Coupon> {
  @override
  Widget build(BuildContext context) {
    CouponDescription couponDescription = widget.couponDescription;
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /*Expanded(
              flex: 1,
                child:  ),*/
              buildCouponDescription(couponDescription),
              buildCouponValidation(couponDescription),
            ],
          ),
          Stack(
            children: <Widget>[
              Image.asset("assets/images/coupon_bg_bottom.png"),
              Text("说明：优惠券不可叠加使用",style: TextStyle(fontSize: 10,color: Colors.white),),
            ],
          )
        ],
      ),
    );
  }

  Widget buildCouponDescription(CouponDescription couponDescription){
    return Stack(
      children: <Widget>[
        Image.asset("assets/images/coupon_bg_left.png"),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(couponDescription.usedAmount,style: TextStyle(fontSize: 40,color: Colors.white),),
              padding: EdgeInsets.only(left: 20.0),),
            Container(
              child: Text("满"+couponDescription.withAmount+"使用",style: TextStyle(fontSize: 10,color: Colors.white)),
              padding: EdgeInsets.only(left: 20.0),),
            //Text(couponDescription.issuedTime+"-"+couponDescription.validUtil,style: TextStyle(fontSize: 16,color: Colors.grey))
          ],
        )
      ],
    );
  }

  Widget buildCouponValidation(CouponDescription couponDescription){
    String startTime = couponDescription.validStartTime.split(" ")[0];
    String endTime = couponDescription.validEndTime.split(" ")[0];
    return Stack(
      children: <Widget>[
        Image.asset("assets/images/coupon_bg_right.png"),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(couponDescription.title,style: TextStyle(fontSize: 20,color: Colors.white),),
              padding: EdgeInsets.only(right: 8.0),),
            Text(startTime+"-"+endTime,style: TextStyle(fontSize: 10,color: Colors.grey))
          ],
        )
      ],
    );
  }
}