class ReceiptModel{

  String? stallID;
  String? highlightedID;
  String? menuID;
  String? receiptID;
  String? custID;
  String? stallName;
  String? menuName;
  String? menuPrice;
  String? quantity;
  String? custName;
  String? custPhone;
  String? status;
  String? totalPrice;
  String? token;
  String? rejectedReason;

  ReceiptModel({this.menuID, this.custID, this.stallID, this.receiptID,this.menuName,this.menuPrice,this.stallName, this.highlightedID, this.quantity, this.custName, this.custPhone, this.status, this.totalPrice,this.token, this.rejectedReason});

  //receive data from server
  factory ReceiptModel.fromMap(map){
    return ReceiptModel(
      stallID: map['stallID'],
      stallName: map['stallName'],
      menuName: map['menuName'],
      menuPrice: map['menuPrice'],
      menuID: map['menuID'],
      highlightedID: map['highlightedID'],
      quantity: map['quantity'],
      receiptID: map['receiptID'],
      custName: map['custName'],
      custPhone: map['custPhone'],
      status: map['status'],
      totalPrice: map['totalPrice'],
      custID: map['custID'],
      token: map['token'],
      rejectedReason: map['rejectedReason'],
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
      'receiptID': receiptID,
      'custName': custName,
      'custPhone': custPhone,
      'status': status,
      'totalPrice': totalPrice,
      'custID': custID,
      'token': token,
      'rejectedReason': rejectedReason,
    };
  }


  //receive data from server
  static ReceiptModel fromJson(Map<String, dynamic> json) => ReceiptModel(
    stallID: json['stallID'],
    stallName: json['stallName'],
    menuName: json['menuName'],
    menuPrice: json['menuPrice'],
    menuID: json['menuID'],
    highlightedID: json['highlightedID'],
    quantity: json['quantity'],
    receiptID: json['receiptID'],
    custName: json['custName'],
    custPhone: json['custPhone'],
    status: json['status'],
    totalPrice: json['totalPrice'],
    custID: json['custID'],
    token: json['token'],
    rejectedReason: json['rejectedReason'],
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
    'receiptID': receiptID,
    'custName': custName,
    'custPhone': custPhone,
    'status': status,
    'totalPrice': totalPrice,
    'custID': custID,
    'token': token,
    'rejectedReason': rejectedReason,
  };
}
