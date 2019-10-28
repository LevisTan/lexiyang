//短信验证bean
class VerificationCodeBean {
  int status;
  Payload payload;

  VerificationCodeBean({this.status,this.payload});

  factory VerificationCodeBean.fromJson(Map<String,dynamic> json) {
    return VerificationCodeBean(
      status: json['status'],
      payload: json['status'] == 200 ? Payload.fromJson(json['payload']) : null,
    );
  }
}

//获取返回的结果，知道发送验证码是否成功即可
class Payload {
  String errmsg;

  Payload({this.errmsg});

  factory Payload.fromJson(Map<String,dynamic> json) {
    return Payload(
      errmsg: json['errmsg']
    );
  }
}