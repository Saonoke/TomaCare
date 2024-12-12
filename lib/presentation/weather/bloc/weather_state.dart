part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherSuccess extends WeatherState {
  final List placemarks;
  final int weather_code;
  final double temperature;
  final double windspeed;
  final WeatherCondition weatherCondition;

  const WeatherSuccess(
      {required this.placemarks,
      required this.weather_code,
      required this.temperature,
      required this.windspeed,
      required this.weatherCondition});

  @override
  List<Object> get props => [placemarks, weather_code];
}

final class WeatherFailed extends WeatherState {
  final String message;

  const WeatherFailed({required this.message});

  @override
  List<Object> get props => [message];
}
