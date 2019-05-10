import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_http_request/HttpUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Imagecut extends StatefulWidget {

  final String imgurl,id;
  Imagecut({this.imgurl,this.id});
  
  @override
  ImagecutState createState() => ImagecutState();
}

class ImagecutState extends State<Imagecut> {
  File imageFile;
  String imageurl;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   imageFile==null?imageurl=widget.imgurl:imageurl=imageFile.path;
   return Scaffold(
      appBar: AppBar(
        title: Text("裁剪头像"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
        actions: <Widget>[
          GestureDetector(
              onTap: (){
                _uploadHeadimg(imageurl);
// .then((_) async {
//                  SharedPreferences sp = await SharedPreferences.getInstance();
//                  String token = sp.getString("token");
//                  RequestManager.baseHeaders = {"token": token};
//                  ResultModel response = await RequestManager.requestPost(
//                      "/repairs/repairsUser/update",
//                      {"id": widget.id, "headimg": url});
//                  print(response);
//                });
                Navigator.pop(context);
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
      body: Center(
        child: Image.file(File(imageurl)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            _cropImage();
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
      return Icon(Icons.crop);
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: widget.imgurl,
      toolbarTitle: 'Cropper',
      toolbarColor: Colors.blue,
      circleShape: true,
      toolbarWidgetColor: Colors.white,
    );
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
      });
      print(imageFile.path);
    }
  }

  Future<void> _uploadHeadimg(String _url) async {
    Dio dio = new Dio();
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(new File(_url), _url),
    });

    Response response = await dio.post(
        "http://115.159.93.175:8281/upload/uploadImg",
        data: formData,
    );
    print(response);

    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders = {"token": token};
    ResultModel resultModel = await RequestManager.requestPost(
        "/repairs/repairsUser/update",
        {"id": widget.id, "headimg": json.decode(response.toString())['fileUploadServer']+json.decode(response.toString())['data']['url']});
    print(resultModel.data);
    Fluttertoast.showToast(msg: json.decode(resultModel.data.toString()).cast<String, dynamic>()['msg']);
  }

}
