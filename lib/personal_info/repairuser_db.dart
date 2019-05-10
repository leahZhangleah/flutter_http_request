class RepairUserDB{
  String id;
  String name;
  String headimg;

  RepairUserDB({this.id, this.name, this.headimg});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'headimg': headimg,
    };
  }

  RepairUserDB.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    headimg = map['headimg'];
  }
}