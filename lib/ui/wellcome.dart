import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/constant.dart';
import 'package:weather/ui/home.dart';

class Wellcome extends StatefulWidget {
  const Wellcome({super.key});

  @override
  State<Wellcome> createState() => _WellcomeState();
}

class _WellcomeState extends State<Wellcome> {
  Future<void> handleRefresh() async {
    return Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    List<City> cities =
        City.citieList.where((city) => city.isDefault == false).toList();
    List<City> selectedCities = City.getListOfCities();
    Size size = MediaQuery.of(context).size;
    Constant myConstant = Constant();
    return Scaffold(
      appBar: AppBar(
        title: Text("${selectedCities.length} Selected"),
        backgroundColor: myConstant.primaryColor,
      ),
      body: LiquidPullToRefresh(
        color: myConstant.primaryColor,
        onRefresh: handleRefresh,
        child: ListView.builder(
          itemCount: cities.length,
          itemBuilder: (context, indext) {
            return Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: size.height * 0.08,
              width: size.width,
              decoration: BoxDecoration(
                border: cities[indext].isSelected == true
                    ? Border.all(
                        color: myConstant.primaryColor.withOpacity(.8),
                        width: 2)
                    : Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                      color: myConstant.primaryColor.withOpacity(.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        cities[indext].isSelected = !cities[indext].isSelected;
                      });
                    },
                    child: Image.asset(
                      cities[indext].isSelected == true
                          ? 'assets/checked.png'
                          : 'assets/unchecked.png',
                      width: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    cities[indext].city,
                    style: TextStyle(
                        color: cities[indext].isSelected
                            ? myConstant.primaryColor
                            : Colors.black54,
                        fontSize: 16),
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myConstant.secondaryColor,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
        },
        child: const Icon(
          Icons.pin_drop,
          color: Colors.white,
        ),
      ),
    );
  }
}
