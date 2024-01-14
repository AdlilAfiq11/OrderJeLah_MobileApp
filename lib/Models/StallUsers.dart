class StallUsers{

  String? uid;
  String? email;
  String? ownerName;
  String? stallName;
  String? ownerPhone;
  String? stallStatus;
  String? category;


  StallUsers({this.uid,this.email,this.ownerName,this.stallName, this.ownerPhone, this.stallStatus, this.category});

  //receive data from server
  factory StallUsers.fromMap(map){
    return StallUsers(
      uid: map['uid'],
      email: map['email'],
      ownerName: map['ownerName'],
      stallName: map['stallName'],
      ownerPhone: map['ownerPhone'],
      stallStatus: map['stallStatus'],
      category: map['category'],

    );
  }
  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'uid': uid,
      'email': email,
      'ownerName': ownerName,
      'stallName': stallName,
      'ownerPhone': ownerPhone,
      'stallStatus': stallStatus,
      'category': category,
    };
  }

  //receive data from server
  static StallUsers fromJson(Map<String, dynamic> json) => StallUsers(
    uid: json['uid'],
    email: json['email'],
    ownerName: json['ownerName'],
    stallName: json['stallName'],
    ownerPhone: json['ownerPhone'],
    stallStatus: json['stallStatus'],
    category: json['category'],
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'uid': uid,
    'email': email,
    'ownerName': ownerName,
    'stallName': stallName,
    'ownerPhone': ownerPhone,
    'stallStatus': stallStatus,
    'category': category,
  };
}