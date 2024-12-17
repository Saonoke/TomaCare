import 'package:tomacare/presentation/weather/bloc/weather_bloc.dart';

class Weather {
  final int weatherCode;
  final WeatherCondition weatherCondition;
  final String time;
  final int temperature;

  const Weather(
      {required this.weatherCondition,
      required this.weatherCode,
      required this.time,
      required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        weatherCondition: json['weatherCode'],
        weatherCode: json['weatherCondition'],
        time: json['time'],
        temperature: json['temperature']);
  }
}
