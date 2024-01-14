class CartModel{

  String? stallID;
  String? highlightedID;
  String? menuID;
  String? custID;
  String? stallName;
  String? menuName;
  String? menuPrice;
  String? quantity;
  String? menuType;
  String? totalPrice;


  CartModel({this.menuID,this.stallID, this.custID, this.menuName,this.menuPrice, this.stallName, this.highlightedID, this.quantity, this.menuType, this.totalPrice});

  //receive data from server
  factory CartModel.fromMap(map){
    return CartModel(
      stallID: map['stallID'],
      stallName: map['stallName'],
      menuName: map['menuName'],
      menuPrice: map['menuPrice'],
      menuID: map['menuID'],
      highlightedID: map['highlightedID'],
      quantity: map['quantity'],
      custID: map['custID'],
      menuType: map['menuType'],
      totalPrice: map['totalPrice'],
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
      'highlightedID': highlightedID,
      'quantity': quantity,
      'custID': custID,
      'menuType': menuType,
      'totalPrice': totalPrice,
    };
  }


  //receive data from server
  static CartModel fromJson(Map<String, dynamic> json) => CartModel(
    stallID: json['stallID'],
    stallName: json['stallName'],
    menuName: json['menuName'],
    menuPrice: json['menuPrice'],
    menuID: json['menuID'],
    highlightedID: json['highlightedID'],
    quantity: json['quantity'],
    custID: json['custID'],
    menuType: json['menuType'],
    totalPrice: json['totalPrice'],
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'stallID': stallID,
    'stallName': stallName,
    'menuName': menuName,
    'menuPrice': menuPrice,
    'menuID': menuID,
    'highlightedID': highlightedID,
    'quantity': quantity,
    'custID': custID,
    'menuType': menuType,
    'totalPrice': totalPrice,
  };
}

