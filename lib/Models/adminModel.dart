
class AdminModel{

  String? name;
  String? email;
  String? category;

  AdminModel({this.name,this.email,this.category});

  //receive data from server
  factory AdminModel.fromMap(map){
    return AdminModel(
      name: map['name'],
      email: map['email'],
      category: map['category'],
    );
  }
  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'name': name,
      'email': email,
      'category': category,
    };
  }

}