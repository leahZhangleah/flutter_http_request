import 'package:flutter/material.dart';
import 'fetch_order_list.dart';
import 'package:connectivity/connectivity.dart';
class Home extends StatefulWidget{
  String title;

  Home({this.title});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: FutureBuilder(
            future: FetchOrderList().fetchYetReceivedOrders(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done){
                return ListView.builder(
                    itemCount: snapshot.data==null?0:snapshot.data.length,
                    itemBuilder: (context,index){
                      return new Container(
                        child: new Center(
                          child: new Text(snapshot.data[index]['title'])
                          // child: new Text(snapshot.data[index]['contactsAddress'])
                        ),
                      );
                    });
              }else if(snapshot.connectionState == ConnectionState.waiting){
                return new CircularProgressIndicator(
                  backgroundColor: Colors.green,
                );
              }
            })
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}