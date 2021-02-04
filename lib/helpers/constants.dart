import 'package:flutter/material.dart';

const kAPIURL = 'https://api.openweathermap.org/data/2.5/onecall';

const TextStyle kWeatherBig = TextStyle(
  fontSize: 90,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);
const TextStyle kWeatherMed = TextStyle(
  fontSize: 45,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);
const TextStyle kWeatherSmall = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);
const TextStyle kWeatherXSmall = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);

const TextStyle kWeatherXXSmall = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);

const BoxDecoration kDailyWeatherStyle = BoxDecoration(
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(50),
    bottom: Radius.circular(50),
  ),
  color: Color(0xFF7B8199),
);
