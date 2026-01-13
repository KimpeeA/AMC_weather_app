import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/models/weather.dart';

void main() {
  group('Weather Model - fromJson', () {
    test('should return a valid Weather object when given a valid OpenWeatherMap Manila response', () {
      final Map<String, dynamic> jsonResponse = {
        "coord": {"lon": 120.9822, "lat": 14.6042},
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 31.02,
          "feels_like": 35.88,
          "temp_min": 29.98,
          "temp_max": 32.15,
          "pressure": 1009,
          "humidity": 66
        },
        "visibility": 10000,
        "wind": {"speed": 4.12, "deg": 100},
        "clouds": {"all": 75},
        "dt": 1700000000,
        "sys": {
          "type": 1,
          "id": 7905,
          "country": "PH",
          "sunrise": 1700000000,
          "sunset": 1700040000
        },
        "timezone": 28800,
        "id": 1701668,
        "name": "Manila",
        "cod": 200
      };

      // 2. Act: Call the fromJson method
      final weather = Weather.fromJson(jsonResponse);

      // 3. Assert: Check that the fields are parsed correctly
      // Note: Adjust the property names according to your Weather model fields
      expect(weather.city, equals('Manila'));
      expect(weather.temperature, equals(31.02));
      expect(weather.humidity, equals(66));
      expect(weather.windSpeed, equals(4.12));
    });
  });
}