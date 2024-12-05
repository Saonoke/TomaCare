part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class getWeather extends WeatherEvent {
  final double longitude;
  final double latitude;

  const getWeather({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [longitude, latitude];
}
