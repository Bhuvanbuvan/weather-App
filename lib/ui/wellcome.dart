import 'package:flutter/material.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/constant.dart';

class Wellcome extends StatefulWidget {
  const Wellcome({super.key});

  @override
  State<Wellcome> createState() => _WellcomeState();
}

class _WellcomeState extends State<Wellcome> {
  @override
  Widget build(BuildContext context) {
    List<City> cities =
        City.citieList.where((city) => city.isDefault == false).toList();
    List<City> selectedCities = City.getListOfCities();
    Size size = MediaQuery.of(context).size;
    Constant _myConstant = Constant();
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCities.length.toString() + "Selected"),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, indext) {
          return Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: size.height * 0.08,
            width: size.width,
            decoration: BoxDecoration(
              border: cities[indext].isSelected == true
                  ? Border.all(
                      color: _myConstant.primaryColor.withOpacity(.8), width: 2)
                  : Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: _myConstant.primaryColor.withOpacity(.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3))
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
                          ? _myConstant.primaryColor
                          : Colors.black54,
                      fontSize: 16),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _myConstant.secondaryColor,
        child: Icon(
          Icons.pin_drop,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        onPressed: () {
          print(selectedCities.length);
        },
      ),
    );
  }
}
