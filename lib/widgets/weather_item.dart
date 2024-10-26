import 'package:flutter/material.dart';

class WeatherItem extends StatelessWidget {
  const WeatherItem({
    super.key,
    required this.windSpeed,
    required this.text,
    required this.unit,
    required this.imageUrl,
  });

  final int windSpeed;
  final String text;
  final String unit;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: Color(0xffE0E8FB),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Image.asset(
            imageUrl,
            width: 50,
            height: 50,
          ),
        ),
        Text(
          windSpeed.toString() + unit,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
