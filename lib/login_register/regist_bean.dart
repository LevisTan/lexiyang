class RegistBean {
  int status;
  Payload payload;

  RegistBean({this.status,this.payload});

  factory RegistBean.fromJson(Map<String,dynamic> json) {
    return RegistBean(
      status: json['status'],
      payload: json['status'] == 200 ? Payload.fromJson(json['payload']) : null
    );
  }
}

class Payload {
  String token;

  Payload({this.token});

  factory Payload.fromJson(Map<String,dynamic> json) {
    return Payload(
      token: json['token']
    );
  }
}