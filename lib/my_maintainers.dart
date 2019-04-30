import 'package:flutter/material.dart';
class MyMaintainers extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyMaintainersState();
  }

}

class MyMaintainersState extends State<MyMaintainers> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("我的维修员"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: buildMaintainerList()),
          buildBottomButtons(),
        ],
      ),
    );
  }

  Widget buildBottomButtons() {
    bool isHighlighted=false;
    return Container(
      color: Colors.black12,
      child: Row(
        children: <Widget>[
          FlatButton(
            child: Text("全选"),
            onPressed: null, //todo, change list item's check status
          ),
          RaisedButton(
            disabledTextColor: Colors.grey,
            disabledColor: Colors.blue,
            shape: RoundedRectangleBorder(),
            child: Text("确认"),
            onPressed: null, //todo, back to select page to show checked results
          )
        ],
      ),
    );
  }

  Widget buildMaintainerList() {

  }
}