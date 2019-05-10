import 'package:flutter/material.dart';
import 'package:flutter_http_request/personal_info/personalmodel.dart';

class PersonalViewMModel {
  List<PersonalModel> items;

  PersonalViewMModel({this.items});

  getPersonalItems() {
    return items = <PersonalModel>[
      PersonalModel(
        leadingIcon: Icons.description,
        text: "我的订单",
      ),
      PersonalModel(
        leadingIcon: Icons.chat,
        text: "收到评价",
      ),
      PersonalModel(
        leadingIcon: Icons.person_outline,
        text: "认证信息",
      ),
    ];
  }
}
