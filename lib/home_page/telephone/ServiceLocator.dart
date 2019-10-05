import 'package:get_it/get_it.dart';
import './TelAndSmsService.dart';

//注册拨打电话服务
GetIt locator = GetIt();
void setupLocator() {
  locator.registerSingleton(TelAndSmsService());
}