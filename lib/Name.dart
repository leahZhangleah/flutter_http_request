import 'package:flutter/material.dart';
import 'change_username_bloc.dart';

class Name extends StatefulWidget {

  final String name;
  Name({this.name});

  @override
  State<StatefulWidget> createState() {
    return new NameState();
  }
}

class NameState extends State<Name> {
   TextEditingController _controller;
   ChangeUsernameBloc _bloc;

  void initState(){
     _controller =new TextEditingController.fromValue(
         new TextEditingValue(text: widget.name));
     _bloc = new ChangeUsernameBloc();
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("修改名字"),
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context,_controller.text)),
          centerTitle: true,
          actions: <Widget>[
            GestureDetector(
              onTap: (){
                if (_controller.text == '') {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => new AlertDialog(title: new Text("请输入昵称") ));
                  return;
                }
                _bloc.input.add(_controller.text);
                Navigator.pop(context,); //_controller.text
              },
                child: Center(
                    child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                '确定',
              ),
            )))
          ],
        ),
        body: Container(
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                    child: Padding(padding: EdgeInsets.only(left: 10),
                        child:TextField(
                        controller: _controller,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "用户名",
                          hintStyle: TextStyle(color:Colors.grey[200],fontSize: 22)
                        )
                    )
                    ),
                )
              ],
            ))
    );
  }
}
