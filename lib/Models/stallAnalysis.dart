
class AnalysisModel{

  int? totalValueCleanliness;
  int? totalValueQuality;
  int? totalValueServices;

  AnalysisModel({this.totalValueCleanliness,this.totalValueQuality,this.totalValueServices});

  //receive data from server
  factory AnalysisModel.fromMap(map){
    return AnalysisModel(
      totalValueCleanliness: map['totalValueCleanliness'],
      totalValueQuality: map['totalValueQuality'],
      totalValueServices: map['totalValueServices'],
    );
  }
  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'totalValueCleanliness': totalValueCleanliness,
      'totalValueQuality': totalValueQuality,
      'totalValueServices': totalValueServices,
    };
  }

  //receive data from server
  static AnalysisModel fromJson(Map<String, dynamic> json) => AnalysisModel(
    totalValueCleanliness: json['totalValueCleanliness'],
    totalValueQuality: json['totalValueQuality'],
    totalValueServices: json['totalValueServices'],
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'totalValueCleanliness': totalValueCleanliness,
    'totalValueQuality': totalValueQuality,
    'totalValueServices': totalValueServices,
  };
}