import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/models/city.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/constant.dart';

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
      print(minutelyDatas[0]);
      print(temperature);
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
                      icon: Icon(Icons.keyboard_arrow_down),
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
      ),
    );
  }
}
