import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';
import 'package:flutter/foundation.dart';

class WeatherService {

  static const String apiKey = '';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';


  static Future<Weather> getWeather(String cityName) async {
    try {
      String url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';

      if (kIsWeb){
        url = "https://corsproxy.io/?" + Uri.encodeComponent(url);
      }
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return Weather.fromJson(data);
      }
      else if (response.statusCode == 404) {
        throw Exception('City Not found');
      }
      else {
        throw Exception('failed to load weather');
      }
    }
    catch(e){
      throw Exception('Error fetching weather: $e');
    }
  }
}