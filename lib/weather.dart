import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'location.dart';

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({@required this.weatherIcon, @required this.weatherImage});
}

class WeatherData {
  WeatherData({@required this.locationData});

  LocationHelper locationData;
  double currentTemperature;
  int currentCondition;

  Future<void> getCurrentTemperature() async {
    Response response = await get(
        'http://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid&units=metric');

    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try {
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
      } catch (e) {
        print(e);
      }
    } else {
      print('Could not fetch temperature!');
    }
  }

  WeatherDisplayData getWeatherDisplayData() {
    if (currentCondition < 600) {
      return WeatherDisplayData(
        weatherIcon: Icon(Icons.cloud),
        weatherImage: AssetImage('assets/cloud.png'),
      );
    } else {
      var now = new DateTime.now();

      if (now.hour >= 15) {
        return WeatherDisplayData(
          weatherImage: AssetImage('assets/night.png'),
          weatherIcon: Icon(Icons.motion_photos_on_outlined),
        );
      } else {
        return WeatherDisplayData(
          weatherIcon: Icon(Icons.flash_auto),
          weatherImage: AssetImage('assets/sunny.png'),
        );
      }
    }
  }
}