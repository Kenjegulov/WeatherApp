import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lesson9/constants/MyColors.dart';
import 'package:flutter_lesson9/constants/MyTexts.dart';
import 'package:flutter_lesson9/constants/iconAPI.dart';
import 'package:flutter_lesson9/model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<WeatherAPI?> fetchData() async {
    Dio dio = Dio();
    await Future.delayed(const Duration(seconds: 3));
    final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather?q=bishkek,&appid=41aa18abb8974c0ea27098038f6feb1b');
    if (response.statusCode == 200) {
      final WeatherAPI weather = WeatherAPI(
          id: response.data["weather"][0]["id"],
          main: response.data["weather"][0]["main"],
          description: response.data["weather"][0]["description"],
          icon: response.data["weather"][0]["icon"],
          temp: response.data["main"]["temp"],
          city: response.data["name"]);
      return weather;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.white,
        title: Center(child: MyText.appBar),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const Text("Интернет иштебей жатат!");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              final pagoda = snapshot.data;
              return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("images/weather.jpg"))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.near_me,
                            color: MyColor.white,
                            size: 60,
                          ),
                          Icon(
                            Icons.location_city,
                            color: MyColor.white,
                            size: 60,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text('${(pagoda!.temp - 273.15).toInt()}',
                            style: TextStyle(
                                color: MyColor.white,
                                fontSize: 70,
                                fontWeight: FontWeight.w500)),
                        Image.network(IconAPI.getIconAPI(pagoda.icon, 2))
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    FittedBox(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(pagoda.description.replaceAll(" ", "\n"),
                            style:
                                TextStyle(color: MyColor.white, fontSize: 70)),
                      ),
                    ),
                    FittedBox(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          pagoda.city,
                          style: TextStyle(color: MyColor.white, fontSize: 80),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Text("Бизге Дата келген жок!");
            }
          } else {
            return const Text("Error");
          }
        },
      ),
    );
  }
}
