
class GeofenceModel{

  double? latitude;
  double? longitude;
  String? radius;
  String? limitDevice;
  int? totalDevice;


  GeofenceModel({this.latitude,this.longitude,this.radius,this.limitDevice,this.totalDevice});

  //receive data from server
  factory GeofenceModel.fromMap(map){
    return GeofenceModel(
      latitude: map['latitude'],
      longitude: map['longitude'],
      radius: map['radius'],
      limitDevice: map['limitDevice'],
      totalDevice: map['totalDevice'],
    );
  }
  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'limitDevice': limitDevice,
      'totalDevice': totalDevice,
    };
  }

  //receive data from server
  static GeofenceModel fromJson(Map<String, dynamic> json) => GeofenceModel(
    latitude: json['latitude'],
    longitude: json['longitude'],
    radius: json['radius'],
    limitDevice: json['limitDevice'],
    totalDevice: json['totalDevice'],
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'latitude': latitude,
    'longitude': longitude,
    'radius': radius,
    'limitDevice': limitDevice,
    'totalDevice': totalDevice,
  };
}