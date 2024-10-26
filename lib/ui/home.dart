import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/models/city.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/constant.dart';
import 'package:weather/ui/detial_page.dart';
import 'package:weather/widgets/weather_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Constant constant = Constant();

  int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading...';
  int humidity = 0;
  int windSpeed = 0;
  var currentDate = 'Loading...';
  String imageUrl = '';
  List minutelyDatas = [];
  String location = 'London';
  var selectedCity = City.getListOfCities();
  List<String> cities = ['London'];
  List consolidatedWeatherList = [];

  void getWeather({required String lat, required String lon}) async {
    var weather = await http.get(Uri.parse(
        'https://api.tomorrow.io/v4/weather/forecast?location=$lat,$lon&apikey=jcrzH286mPEmv5VHQW1XdKw2NV0kuUxK'));
    var result = json.decode(weather.body);
    var datas = result['timelines']['minutely'];

    setState(() {
      for (var i = 0; i < 7; i++) {
        minutelyDatas.add(datas[i]);
      }
      // Safely check if the temperature value exists before converting
      temperature =
          minutelyDatas[0]['values']['temperature'].toDouble().round();
      weatherStateName = "clear";
      humidity = minutelyDatas[0]['values']['humidity'].toDouble().round();
      windSpeed = minutelyDatas[0]['values']['windSpeed'].toDouble().round();
      maxTemp = minutelyDatas[0]['values']['temperature'].toDouble().round();
      var mydate = DateTime.parse(minutelyDatas[0]['time']);
      currentDate = DateFormat('EEEE,d MMMM').format(mydate);
      imageUrl = weatherStateName.replaceAll(' ', '').toLowerCase();
      consolidatedWeatherList = minutelyDatas.toSet().toList();
    });
  }

  @override
  void initState() {
    getWeather(lat: "42.3478", lon: "-71.0466");
    for (var i = 0; i < selectedCity.length; i++) {
      cities.add(selectedCity[i].city);
    }
    super.initState();
  }

  final Shader linearGradient = const LinearGradient(
          colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)])
      .createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _homeAppBar(size),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Text(
              currentDate,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                color: constant.primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                      color: constant.primaryColor.withOpacity(.5),
                      offset: const Offset(0, 25),
                      blurRadius: 10,
                      spreadRadius: -12)
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -40,
                    left: 20,
                    child: imageUrl == ''
                        ? const Text('')
                        : Image.asset(
                            'assets/$imageUrl.png',
                            width: 150,
                          ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: Text(
                      weatherStateName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            temperature.toString(),
                            style: TextStyle(
                              fontSize: 80,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                        ),
                        Text(
                          'o',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherItem(
                    windSpeed: windSpeed,
                    text: "Wind Speed",
                    unit: "Km/h",
                    imageUrl: 'assets/windspeed.png',
                  ),
                  WeatherItem(
                    windSpeed: humidity,
                    text: "Humidity",
                    unit: "Km/h",
                    imageUrl: 'assets/humidity.png',
                  ),
                  WeatherItem(
                    windSpeed: temperature,
                    text: "Temperature",
                    unit: "C",
                    imageUrl: 'assets/max-temp.png',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Today",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Next 7 Days',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: constant.primaryColor,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: consolidatedWeatherList.length,
                itemBuilder: (context, index) {
                  String today = DateTime.now().toString().substring(0, 10);
                  String selectedDate = consolidatedWeatherList[index]['time']
                      .toString()
                      .substring(0, 10);
                  var parsedDate = DateTime.parse(selectedDate);
                  var newDate =
                      DateFormat('EEEE').format(parsedDate).substring(0, 3);
                  var futureWeatherName = "Clear";
                  var weatherUrl =
                      futureWeatherName.replaceAll(' ', '').toLowerCase();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetialPage(
                                  consolidatedWeatherList:
                                      consolidatedWeatherList,
                                  selectedId: index,
                                  location: location,
                                )),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin:
                          const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                      width: 100,
                      decoration: BoxDecoration(
                          color: selectedDate == today
                              ? constant.primaryColor
                              : Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1),
                              color: today == selectedDate
                                  ? constant.primaryColor
                                  : Colors.black54.withOpacity(.2),
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${consolidatedWeatherList[index]["values"]['temperature'].toDouble().round()}C',
                            style: TextStyle(
                                fontSize: 17,
                                color: selectedDate == today
                                    ? Colors.white
                                    : constant.primaryColor),
                          ),
                          Image.asset(
                            'assets/$weatherUrl.png',
                            width: 40,
                          ),
                          Text(
                            newDate,
                            style: TextStyle(
                                color: selectedDate == today
                                    ? Colors.white
                                    : constant.primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _homeAppBar(Size size) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10.0), // Make sure this is defined
              child: Image.asset(
                'assets/profile.png',
                width: 40,
                height: 40,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/pin.png',
                  width: 20,
                ),
                const SizedBox(
                  width: 4,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: location,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: cities.map((String location) {
                      return DropdownMenuItem(
                          value: location, child: Text(location));
                    }).toList(),
                    onChanged: (String? newLocation) {
                      setState(() {
                        location = newLocation!;
                        getWeather(lat: "42.3478", lon: "-71.0466");
                      });
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
