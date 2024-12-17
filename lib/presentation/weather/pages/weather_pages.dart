import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tomacare/domain/entities/weather.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/weather/bloc/weather_bloc.dart';
import 'package:http/http.dart' as http;

class WeatherPages extends StatelessWidget {
  const WeatherPages({super.key, required this.position});
  final Position? position;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: WeatherScreen(
        position: position,
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, required this.position});
  final Position? position;
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: neutral06,
        ),
        backgroundColor: primaryColor,
        body: BlocConsumer<WeatherBloc, WeatherState>(
            builder: (context, state) {
              switch (state) {
                case WeatherInitial():
                  context.watch<WeatherBloc>().add(getWeatherDetails(
                      latitude: widget.position!.latitude,
                      longitude: widget.position!.longitude));
                  return Skeletonizer(
                    enabled: true,
                    enableSwitchAnimation: true,
                    child: Card(
                      child: ListTile(
                        title: Text('Item number as title'),
                        subtitle: const Text('Subtitle here'),
                        trailing: const Icon(
                          Icons.ac_unit,
                          size: 32,
                        ),
                      ),
                    ),
                  );
                case WeatherSuccessTime():
                  List<Weather> weathers = state.weathers;
                  return Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state.placemarks[0].subAdministrativeArea.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: neutral06),
                        ),
                        weatherIcon(WeatherCondition.clear),
                        Text(
                          '18' + '℃',
                          style: TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.bold,
                              color: neutral06),
                        ),
                        Text(
                          state.weathers[0].weatherCondition.name,
                          style: TextStyle(fontSize: 16, color: neutral06),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          width: double.maxFinite,
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: weathers.length,
                            itemBuilder: (context, index) {
                              final Weather weather = weathers[index];
                              return Container(
                                margin: EdgeInsets.only(right: 12),
                                width: 120,
                                child: Column(
                                  children: [
                                    Text(
                                      DateFormat('HH:mm')
                                          .format(DateTime.parse(weather.time)),
                                      style: TextStyle(color: neutral06),
                                    ),
                                    weatherIcon(weather.weatherCondition),
                                    Text(
                                      weather.temperature.toString() + '℃',
                                      style: TextStyle(color: neutral06),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                default:
                  return Text('failed');
              }
            },
            listener: (context, state) {}));
  }

  Icon weatherIcon(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return Icon(
          Iconsax.sun_1,
          size: 92,
          color: neutral06,
        );
      case WeatherCondition.cloudy:
        return Icon(
          Iconsax.cloud_sunny,
          size: 92,
          color: neutral06,
        );
      case WeatherCondition.rainy:
        return Icon(
          Iconsax.cloud_drizzle,
          size: 92,
          color: neutral06,
        );
      case WeatherCondition.snowy:
        return Icon(
          Iconsax.sun,
          size: 92,
          color: neutral06,
        );
      default:
        return Icon(
          Iconsax.cloud_cross,
          size: 92,
          color: neutral06,
        );
    }
  }
}
