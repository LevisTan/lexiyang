class LoginBean {
  int status;
  Payload payload;

  LoginBean({this.status,this.payload});

  factory LoginBean.fromJson(Map<String,dynamic> json) {
    return LoginBean(
      status: json['status'],
      payload: json['status'] == 200 ? Payload.fromJson(json['payload']) : null
    );
  }
}

class Payload {
  String token;
  String score;

  Payload({this.token,this.score});

  factory Payload.fromJson(Map<String,dynamic> json) {
    return Payload(
      token: json['token'],
      score: json['score']
    );
  }
}