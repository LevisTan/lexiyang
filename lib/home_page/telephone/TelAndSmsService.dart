import 'package:url_launcher/url_launcher.dart';

//拨打系统电话方法
//参考博客：https://segmentfault.com/a/1190000019691815?utm_source=tag-newest
class TelAndSmsService {
  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email) => launch("mailto:$email");
}