//该dart文件定义乐夕阳整个应用的所有url接口

class MyUrls {
  //按城市名查看天气
  static final String FIND_CITY_WEATHER = 'http://api.niyueling.cn/api/findCityWeather';
  //短信验证接口
  static final String GET_VERIFICATION_CODE = 'http://api.niyueling.cn/users/apply_code';
  //注册接口
  static final String REGISTER = 'http://api.niyueling.cn/users/regist';
  //登录接口
  static final String LOGIN = 'http://api.niyueling.cn/users/login';
}