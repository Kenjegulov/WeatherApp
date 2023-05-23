import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_lesson9/constants/weather.dart';

import '../constants/MyAPI.dart';
import '../model.dart';

class MyFetchData {
  static Future<void> fetchData([String? url]) async {
    Dio dio = Dio();
    final response = await dio.get(MyAPI.getWeatherAPI(url ?? "bishkek"));
    if (response.statusCode == 200) {
      MyWeather.weatherAPI = WeatherAPI(
        id: response.data["weather"][0]["id"],
        main: response.data["weather"][0]["main"],
        description: response.data["weather"][0]["description"],
        icon: response.data["weather"][0]["icon"],
        temp: response.data["main"]["temp"],
        city: response.data["name"],
      );
    }
  }
}
