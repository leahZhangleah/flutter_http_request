class RepairUserDB{
  String id;
  String name;
  String headimg;
  int time;

  RepairUserDB({this.id, this.name, this.headimg,this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'headimg': headimg,
      'time':time
    };
  }

  RepairUserDB.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    headimg = map['headimg'];
    time = map['time'];
  }
}