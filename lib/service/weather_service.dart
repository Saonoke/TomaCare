import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class WeatherService {
  Future<Map<String, dynamic>> getWeather(
      double longitude, double latitude) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }
}
