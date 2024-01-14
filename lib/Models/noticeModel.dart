
class NoticeModel{

  String? noticeID;
  String? stallID;
  String? noticeDate;
  String? noticeText;

  NoticeModel({ this.noticeID, this.stallID, this.noticeDate, this.noticeText});

  //receive data from server
  factory NoticeModel.fromMap(map){
    return NoticeModel(
      noticeID: map['noticeID'],
      stallID: map['stallID'],
      noticeDate: map['noticeDate'],
      noticeText: map['noticeText'],
    );
  }
  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'noticeID': noticeID,
      'stallID': stallID,
      'noticeDate': noticeDate,
      'noticeText': noticeText,
    };
  }

  //receive data from server
  static NoticeModel fromJson(Map<String, dynamic> json) => NoticeModel(
    noticeID: json['noticeID'],
    stallID: json['stallID'],
    noticeDate: json['noticeDate'],
    noticeText: json['noticeText'],
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'noticeID': noticeID,
    'stallID': stallID,
    'noticeDate': noticeDate,
    'noticeText': noticeText,
  };
}
