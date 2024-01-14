
class StallMenu{

  String? stallID;
  String? stallName;
  String? menuName;
  String? menuPrice;
  String? menuID;
  String? quantity;
  String? custID;
  String? menuStatus;
  String? menuType;
  String? menuCounter;


  StallMenu({this.menuID,this.custID,this.stallID,this.menuName,this.menuPrice,this.stallName, this.quantity, this.menuStatus, this.menuType, this.menuCounter});

  //receive data from server
  factory StallMenu.fromMap(map){
    return StallMenu(
      stallID: map['stallID'],
      stallName: map['stallName'],
      menuName: map['menuName'],
      menuPrice: map['menuPrice'],
      menuID: map['menuID'],
      quantity: map['quantity'],
      custID: map['custID'],
      menuStatus: map['menuStatus'],
      menuType: map['menuType'],
      menuCounter: map['menuCounter'],
    );
  }

  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'stallID': stallID,
      'stallName': stallName,
      'menuName': menuName,
      'menuPrice': menuPrice,
      'menuID': menuID,
      'quantity': quantity,
      'custID': custID,
      'menuStatus': menuStatus,
      'menuType': menuType,
      'menuCounter': menuCounter,
    };
  }


  //receive data from server
  static StallMenu fromJson(Map<String, dynamic> json) => StallMenu(
    stallID: json['stallID'],
    stallName: json['stallName'],
    menuName: json['menuName'],
    menuPrice: json['menuPrice'],
    menuID: json['menuID'],
    quantity: json['quantity'],
    custID: json['custID'],
    menuStatus: json['menuStatus'],
    menuType: json['menuType'],
    menuCounter: json['menuCounter'],
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
      'stallID': stallID,
      'stallName': stallName,
      'menuName': menuName,
      'menuPrice': menuPrice,
      'menuID': menuID,
      'quantity': quantity,
      'custID': custID,
      'menuStatus': menuStatus,
      'menuType': menuType,
      'menuCounter': menuCounter,
  };
}



class HighlightedMenu{

  String? stallID;
  String? stallName;
  String? menuName;
  String? menuPrice;
  String? menuID;
  String? highlightID;
  String? quantity;
  String? menuStatus;
  String? menuType;
  String? menuCounter;


  HighlightedMenu({this.menuID,this.stallID, this.highlightID, this.menuName,this.menuPrice,this.stallName,this.quantity, this.menuStatus, this.menuType, this.menuCounter});

  //receive data from server
  factory HighlightedMenu.fromMap(map){
    return HighlightedMenu(
      stallID: map['stallID'],
      stallName: map['stallName'],
      menuName: map['menuName'],
      menuPrice: map['menuPrice'],
      menuID: map['menuID'],
      highlightID: map['highlightID'],
      quantity: map['quantity'],
      menuStatus: map['menuStatus'],
      menuType: map['menuType'],
      menuCounter: map['menuCounter'],
    );
  }
  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'stallID': stallID,
      'stallName': stallName,
      'menuName': menuName,
      'menuPrice': menuPrice,
      'menuID': menuID,
      'highlightID': highlightID,
      'quantity': quantity,
      'menuStatus': menuStatus,
      'menuType': menuType,
      'menuCounter': menuCounter,
    };
  }


  //receive data from server
  static HighlightedMenu fromJson(Map<String, dynamic> json) => HighlightedMenu(
    stallID: json['stallID'],
    stallName: json['stallName'],
    menuName: json['menuName'],
    menuPrice: json['menuPrice'],
    menuID: json['menuID'],
    highlightID: json['highlightID'],
    quantity: json['quantity'],
    menuStatus: json['menuStatus'],
    menuType: json['menuType'],
    menuCounter: json['menuCounter'],
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'stallID': stallID,
    'stallName': stallName,
    'menuName': menuName,
    'menuPrice': menuPrice,
    'menuID': menuID,
    'highlightID': highlightID,
    'quantity': quantity,
    'menuStatus': menuStatus,
    'menuType': menuType,
    'menuCounter': menuCounter,
  };
}

