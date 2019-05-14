import 'package:flutter/material.dart';
import 'personal_info/base_provider.dart';
import 'personal_info/personal_info_api.dart';
import 'personal_info/mine_page.dart';
import 'personal_info/change_personal_info_bloc.dart';
class TestHome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
          appBar: AppBar(
            title: Text("Test Home"),
            centerTitle: true,
          ),
          body: Center(
            child: RaisedButton(
                child: Text("Go to My Page"),
                onPressed: (){
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context){
                        return MinePage();
                      }
                  ));
                }),
          ),
        );
  }

}