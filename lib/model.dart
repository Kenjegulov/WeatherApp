class WeatherAPI {
  final int id;
  final String main;
  final String description;
  final String icon;
  final double temp;
  final String city;

  WeatherAPI(
      {required this.id,
      required this.main,
      required this.description,
      required this.icon,
      required this.temp,
      required this.city});
}
