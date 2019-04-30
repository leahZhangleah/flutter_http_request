import 'maintainer.dart';
class MyMaintainerResponse{
  String msg;
  int code;
  String fileUploadServer;
  bool state;
  List<Maintainer> list;

  MyMaintainerResponse(
      {this.msg, this.code, this.fileUploadServer, this.state, this.list});

  MyMaintainerResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    fileUploadServer = json['fileUploadServer'];
    state = json['state'];
    if (json['list'] != null) {
      list = new List<Maintainer>();
      json['list'].forEach((v) {
        list.add(new Maintainer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['fileUploadServer'] = this.fileUploadServer;
    data['state'] = this.state;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}