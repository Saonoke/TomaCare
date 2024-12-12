import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';

import 'package:tomacare/service/weather_service.dart';

part 'weather_event.dart';
part 'weather_state.dart';

enum WeatherCondition {
  clear,
  rainy,
  cloudy,
  snowy,
  unknown,
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService weatherService = WeatherService();
  WeatherBloc() : super(WeatherInitial()) {
    on<getWeather>((event, emit) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(event.latitude, event.longitude);
      try {
        final Map<String, dynamic> response =
            await weatherService.getWeather(event.longitude, event.latitude);

        final current_weather = response['current_weather'];
        final WeatherCondition condition =
            getWeatherCondition(current_weather['weathercode']);

        emit(WeatherSuccess(
            placemarks: placemarks,
            weather_code: current_weather['weathercode'],
            temperature: current_weather['temperature'],
            windspeed: current_weather['windspeed'],
            weatherCondition: condition));
      } catch (e) {
        emit((WeatherFailed(message: 'gagal fetch weather')));
      }
    });
  }
}

WeatherCondition getWeatherCondition(int weather_code) {
  switch (weather_code) {
    case 0:
      return WeatherCondition.clear;
    case 1:
    case 2:
    case 3:
    case 45:
    case 48:
      return WeatherCondition.cloudy;
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
    case 95:
    case 96:
    case 99:
      return WeatherCondition.rainy;
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return WeatherCondition.snowy;
    default:
      return WeatherCondition.unknown;
  }
}
