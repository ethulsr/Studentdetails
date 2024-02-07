class StudentModel {
  int? id;
  final String name;
  final String age;
  final String cls;
  final String address;
  final String img;
  StudentModel(
      {required this.name,
      required this.age,
      required this.cls,
      required this.address,
      required this.img,
      this.id});

  //static StudentModel fromMap(Map<String, Object?> map)

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      cls: map['class'],
      address: map['address'],
      img: map['img'] ?? 'nothing',
    );

    // return StudentModel(name: name, age: age, cls: cls, address: address, img: img, id: id);
  }

  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'class': cls,
      'address': address,
      'img': img
    };
  }
}
