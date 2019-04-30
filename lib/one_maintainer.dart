import 'package:flutter/material.dart';
import 'maintainer.dart';
class OneMaintainer extends StatefulWidget{
  Maintainer maintainer;

  OneMaintainer({this.maintainer});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OneMaintainerState();
  }
}

class OneMaintainerState extends State<OneMaintainer> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(widget.maintainer.name),
          Checkbox(
            value: isChecked,
            onChanged: (value){
              setState(() {
                isChecked = !isChecked;
              });
            })
        ],
      ),
    );
  }
}