import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> getWeather(
      double longitude, double latitude) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getWeatherDetail(
      double longitude, double latitude) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=-7.9797&longitude=112.6304&current=temperature_2m&hourly=temperature_2m,weather_code&timezone=auto');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }
}
