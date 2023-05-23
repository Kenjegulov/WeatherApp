import 'package:dio/dio.dart';
import 'package:flutter_lesson9/constants/Citites.dart';
import 'package:flutter_lesson9/constants/weather.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/MyAPI.dart';
import '../model.dart';

import 'package:flutter/material.dart';

class MyLocation {
  static Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition();
    Dio dio = Dio();
    final response = await dio
        .get(MyAPI.currentAddress(position.latitude, position.longitude));
    if (response.statusCode == 200) {
      MyWeather.weatherAPI = WeatherAPI(
        id: response.data["current"]["weather"][0]["id"],
        main: response.data["current"]["weather"][0]["main"],
        description: response.data["current"]["weather"][0]["description"],
        icon: response.data["current"]["weather"][0]["icon"],
        temp: response.data["current"]["temp"],
        city: response.data["timezone"],
      );
    }
  }
}
