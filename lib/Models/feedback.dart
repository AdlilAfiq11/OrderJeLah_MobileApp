
class FeedbackModel{

  String? feedbackID;
  String? stallID;
  String? stallName;
  String? QualityFeedback;
  String? CleanFeedback;
  String? ServiceFeedback;
  String? QualityFeedbackValue;
  String? CleanFeedbackValue;
  String? ServiceFeedbackValue;


  FeedbackModel({ this.feedbackID, this.stallID, this.stallName,this.QualityFeedback,this.CleanFeedback,this.ServiceFeedback, this.QualityFeedbackValue,this.CleanFeedbackValue,this.ServiceFeedbackValue});

  //receive data from server
  factory FeedbackModel.fromMap(map){
    return FeedbackModel(
      feedbackID: map['feedbackID'],
      stallID: map['stallID'],
      stallName: map['stallName'],
      QualityFeedback: map['QualityFeedback'],
      CleanFeedback: map['CleanFeedback'],
      ServiceFeedback: map['ServiceFeedback'],
      QualityFeedbackValue: map['QualityFeedbackValue'],
      CleanFeedbackValue: map['CleanFeedbackValue'],
      ServiceFeedbackValue: map['ServiceFeedbackValue'],
    );
  }
  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'feedbackID': feedbackID,
      'stallID': stallID,
      'stallName': stallName,
      'QualityFeedback': QualityFeedback,
      'CleanFeedback': CleanFeedback,
      'ServiceFeedback': ServiceFeedback,
      'QualityFeedbackValue': QualityFeedbackValue,
      'CleanFeedbackValue': CleanFeedbackValue,
      'ServiceFeedbackValue': ServiceFeedbackValue,
    };
  }

  //receive data from server
  static FeedbackModel fromJson(Map<String, dynamic> json) => FeedbackModel(
    feedbackID: json['feedbackID'],
    stallID: json['stallID'],
    stallName: json['stallName'],
    QualityFeedback: json['QualityFeedback'],
    CleanFeedback: json['CleanFeedback'],
    ServiceFeedback: json['ServiceFeedback'],
    QualityFeedbackValue: json['QualityFeedbackValue'],
    CleanFeedbackValue: json['CleanFeedbackValue'],
    ServiceFeedbackValue: json['ServiceFeedbackValue'],
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'feedbackID': feedbackID,
    'stallID': stallID,
    'stallName': stallName,
    'QualityFeedback': QualityFeedback,
    'CleanFeedback': CleanFeedback,
    'ServiceFeedback': ServiceFeedback,
    'QualityFeedbackValue': QualityFeedbackValue,
    'CleanFeedbackValue': CleanFeedbackValue,
    'ServiceFeedbackValue': ServiceFeedbackValue,
  };
}
