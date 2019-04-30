class Maintainer{
  String id;
  String parentId;
  String phone;
  String password;
  String salt;
  String name;
  String headimg;
  int type;
  int authentication;
  String createTime;
  String updateTime;
  int status;

  Maintainer(
      {this.id,
        this.parentId,
        this.phone,
        this.password,
        this.salt,
        this.name,
        this.headimg,
        this.type,
        this.authentication,
        this.createTime,
        this.updateTime,
        this.status});

  Maintainer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parentId'];
    phone = json['phone'];
    password = json['password'];
    salt = json['salt'];
    name = json['name'];
    headimg = json['headimg'];
    type = json['type'];
    authentication = json['authentication'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['salt'] = this.salt;
    data['name'] = this.name;
    data['headimg'] = this.headimg;
    data['type'] = this.type;
    data['authentication'] = this.authentication;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['status'] = this.status;
    return data;
  }
}