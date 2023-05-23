class MyAPI {
  static String currentAddress(double latitude, double longitude) =>
      'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&exclude=hourly,daily,minutely&appid=41aa18abb8974c0ea27098038f6feb1b';

  static String getIconAPI(String iconData, int iconSize) {
    return "https://openweathermap.org/img/wn/${iconData}@${iconSize}x.png";
  }

  static String getWeatherAPI(String url) {
    return 'https://api.openweathermap.org/data/2.5/weather?q=$url,&appid=41aa18abb8974c0ea27098038f6feb1b';
  }
}
