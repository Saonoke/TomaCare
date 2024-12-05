import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';

import 'package:tomacare/service/weather_service.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService weatherService = WeatherService();
  WeatherBloc() : super(WeatherInitial()) {
    on<getWeather>((event, emit) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(event.latitude, event.longitude);
      try {
        final Map<String, dynamic> response =
            await weatherService.getWeather(event.longitude, event.latitude);
        print(response['current_weather']);
        final current_weather = response['current_weather'];
        emit(WeatherSuccess(
            placemarks: placemarks,
            weather_code: current_weather['weathercode'],
            temperature: current_weather['temperature'],
            windspeed: current_weather['windspeed']));
      } catch (e) {
        print(e);
        emit((WeatherFailed(message: 'gagal fetch weather')));
      }
    });
  }
}
