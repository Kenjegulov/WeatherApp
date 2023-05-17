class IconAPI {
  static String getIconAPI(String iconData, int iconSize) {
    return "https://openweathermap.org/img/wn/${iconData}@${iconSize}x.png";
  }
}
