import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/models/constant.dart';
import 'package:weather/ui/wellcome.dart';
import 'package:weather/widgets/weather_item.dart';

class DetialPage extends StatefulWidget {
  final List consolidatedWeatherList;
  final int selectedId;
  final String location;
  const DetialPage(
      {super.key,
      required this.consolidatedWeatherList,
      required this.selectedId,
      required this.location});

  @override
  State<DetialPage> createState() => _DetialPageState();
}

class _DetialPageState extends State<DetialPage> {
  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constant constant = Constant();
    final Shader linearGradient = const LinearGradient(
            colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)])
        .createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    int selectedIndex = widget.selectedId;
    var weatherStateName =
        widget.consolidatedWeatherList[selectedIndex]['weather'][0]['main'];
    imageUrl = weatherStateName.replaceAll(' ', '').toLowerCase();
    return Scaffold(
      backgroundColor: constant.secondaryColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: constant.secondaryColor,
        elevation: 0.0,
        title: Text(
          widget.location,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Wellcome()));
                },
                icon: const Icon(Icons.settings)),
          )
        ],
      ),
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 150,
              width: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.consolidatedWeatherList.length,
                itemBuilder: (context, index) {
                  var futureWeatherNews = widget.consolidatedWeatherList[index]
                          ['weather'][0]['main']
                      .toString();
                  ;
                  String selectedDate = widget.consolidatedWeatherList[index]
                          ['dt_txt']
                      .toString()
                      .substring(0, 10);
                  var weatherUrl =
                      futureWeatherNews.replaceAll(' ', '').toLowerCase();
                  var parsedDate = DateTime.parse(selectedDate);
                  var newDate =
                      DateFormat('EEEE').format(parsedDate).substring(0, 3);
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.only(right: 20),
                    width: 80,
                    decoration: BoxDecoration(
                        color: index == selectedIndex
                            ? Colors.white
                            : const Color(0xff9ebcf9),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color: Colors.blue.withOpacity(.3))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(widget.consolidatedWeatherList[index]['main']['temp'].toDouble() - 273.15).toDouble().round()}C',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: index == selectedIndex
                                  ? constant.primaryColor
                                  : Colors.white),
                        ),
                        Image.asset(
                          'assets/$weatherUrl.png',
                          width: 40,
                        ),
                        Text(
                          newDate,
                          style: TextStyle(
                              color: index == selectedIndex
                                  ? constant.primaryColor
                                  : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * .55,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    right: 20,
                    left: 20,
                    child: Container(
                      width: size.width * .7,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.center,
                              colors: [
                                Color(0xffa9c1f5),
                                Color(0xff6696f5),
                              ]),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 25),
                                color: Colors.blue.withOpacity(.1),
                                blurRadius: 3,
                                spreadRadius: -10),
                          ]),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -50,
                            left: 20,
                            child: Image.asset(
                              'assets/$imageUrl.png',
                              width: 150,
                            ),
                          ),
                          Positioned(
                            top: 110,
                            left: 40,
                            child: Text(
                              weatherStateName,
                              style: const TextStyle(
                                fontSize: 29,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: size.width * .8,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WeatherItem(
                                    windSpeed: (widget.consolidatedWeatherList[
                                                    selectedIndex]['wind']
                                                    ['speed']
                                                .toDouble() *
                                            3.6)
                                        .toDouble()
                                        .round(),
                                    text: "Wind Speed",
                                    unit: "Km/h",
                                    imageUrl: 'assets/windspeed.png',
                                  ),
                                  WeatherItem(
                                    windSpeed: widget
                                        .consolidatedWeatherList[selectedIndex]
                                            ['main']['humidity']
                                        .toDouble()
                                        .round(),
                                    text: "Humidity",
                                    unit: " ",
                                    imageUrl: 'assets/humidity.png',
                                  ),
                                  WeatherItem(
                                    windSpeed: (widget.consolidatedWeatherList[
                                                    selectedIndex]['main']
                                                    ['temp']
                                                .toDouble() -
                                            273.15)
                                        .toDouble()
                                        .round(),
                                    text: "Temperature",
                                    unit: "C",
                                    imageUrl: 'assets/max-temp.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (widget.consolidatedWeatherList[selectedIndex]
                                                  ['main']['temp']
                                              .toDouble() -
                                          273.15)
                                      .toDouble()
                                      .round()
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = linearGradient),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = linearGradient),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 250,
                    left: 20,
                    child: SizedBox(
                      height: 230,
                      width: size.width * .9,
                      child: ListView.builder(
                        itemCount: widget.consolidatedWeatherList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var futureWeatherNews = widget
                              .consolidatedWeatherList[index]['weather'][0]
                                  ['main']
                              .toString();
                          ;
                          String selectedDate = widget
                              .consolidatedWeatherList[index]['dt_txt']
                              .toString()
                              .substring(0, 10);
                          var futureWeatherUrl = futureWeatherNews
                              .replaceAll(' ', '')
                              .toLowerCase();
                          var myDate = DateTime.parse(selectedDate);
                          var currentDate =
                              DateFormat('d MMMM , EEEE').format(myDate);
                          return Container(
                            margin: const EdgeInsets.only(
                                bottom: 5, top: 10, right: 10, left: 10),
                            width: size.width,
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          constant.primaryColor.withOpacity(.1),
                                      spreadRadius: 5,
                                      blurRadius: 20,
                                      offset: const Offset(0, 3))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currentDate,
                                    style: const TextStyle(
                                      color: Color(0xff6696f5),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "32",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        "/",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        (widget.consolidatedWeatherList[
                                                        selectedIndex]['main']
                                                        ['temp']
                                                    .toDouble() -
                                                273.15)
                                            .toDouble()
                                            .round()
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Image.asset(
                                        'assets/$futureWeatherUrl.png',
                                        width: 30,
                                      ),
                                      Text(weatherStateName)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
