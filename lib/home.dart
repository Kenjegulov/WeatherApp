import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lesson9/constants/MyCitites.dart';
import 'package:flutter_lesson9/constants/MyColors.dart';
import 'package:flutter_lesson9/constants/MyTexts.dart';
import 'package:flutter_lesson9/constants/MyAPI.dart';
import 'package:flutter_lesson9/model.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WeatherAPI? weather;

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition();
    Dio dio = Dio();
    final response = await dio
        .get(MyAPI.currentAddress(position.latitude, position.longitude));
    setState(() {
      // print(response);
      if (response.statusCode == 200) {
        weather = WeatherAPI(
          id: response.data["current"]["weather"][0]["id"],
          main: response.data["current"]["weather"][0]["main"],
          description: response.data["current"]["weather"][0]["description"],
          icon: response.data["current"]["weather"][0]["icon"],
          temp: response.data["current"]["temp"],
          city: response.data["timezone"],
        );
      }
    });
  }

  Future<void> fetchData([String? url]) async {
    Dio dio = Dio();
    final response = await dio.get(MyAPI.getWeatherAPI(url ?? "bishkek"));
    setState(() {
      if (response.statusCode == 200) {
        weather = WeatherAPI(
          id: response.data["weather"][0]["id"],
          main: response.data["weather"][0]["main"],
          description: response.data["weather"][0]["description"],
          icon: response.data["weather"][0]["icon"],
          temp: response.data["main"]["temp"],
          city: response.data["name"],
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.white,
        title: Center(child: MyText.appBar),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("images/weather.jpg"),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      await getLocation();
                    },
                    icon: Icon(
                      Icons.near_me,
                      color: MyColor.white,
                      size: 60,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      showBottom();
                    },
                    icon: Icon(
                      Icons.location_city,
                      color: MyColor.white,
                      size: 60,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  '${(weather!.temp - 273.15).toInt()}',
                  style: TextStyle(
                      color: MyColor.white,
                      fontSize: 70,
                      fontWeight: FontWeight.w500),
                ),
                Image.network(
                  MyAPI.getIconAPI(weather!.icon, 2),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            FittedBox(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  weather!.description.replaceAll(" ", "\n"),
                  style: TextStyle(color: MyColor.white, fontSize: 70),
                ),
              ),
            ),
            FittedBox(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  weather!.city,
                  style: TextStyle(color: MyColor.white, fontSize: 80),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showBottom() async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[700],
          ),
          child: ListView.builder(
            itemCount: MyCity.cities.length,
            itemBuilder: (context, index) {
              final city = MyCity.cities[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    setState(() {
                      weather = null;
                    });
                    fetchData(city);
                    Navigator.pop(context);
                  },
                  title: Text(
                    '$city',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
