
class UserModel{

  String? name;
  String? phone;
  String? uid;
  String? email;
  String? token;
  String? status;
  String? category;
  String? account;

  UserModel({this.name,this.phone,this.uid,this.email,this.token, this.status, this.category, this.account});

  //receive data from server
factory UserModel.fromMap(map){
  return UserModel(

    name: map['name'],
    phone: map['phone'],
    email: map['email'],
    uid: map['uid'],
    token: map['token'],
    status: map['status'],
    category: map['category'],
    account: map['account'],
  );
}
  //sending data to server
Map<String,dynamic> toMap(){
  return{
    'name': name,
    'phone': phone,
    'email': email,
    'uid': uid,
    'token': token,
    'status': status,
    'category': category,
    'account': account,
  };
  }

  //receive data from server
  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    uid: json['uid'],
    token: json['token'],
    status: json['status'],
    category: json['category'],
    account: json['account'],
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'name': name,
    'phone': phone,
    'email': email,
    'uid': uid,
    'token': token,
    'status': status,
    'category': category,
    'account': account,
  };
}
