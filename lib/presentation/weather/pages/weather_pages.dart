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
  const WeatherPages(
      {super.key,
      required this.position,
      required this.conditon,
      required this.temperature});
  final Position? position;
  final WeatherCondition conditon;
  final double temperature;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: WeatherScreen(
        position: position,
        conditon: conditon,
        temperature: temperature,
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen(
      {super.key,
      required this.position,
      required this.conditon,
      required this.temperature});
  final Position? position;
  final WeatherCondition conditon;
  final double temperature;
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state.placemarks[0].subAdministrativeArea.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: neutral06),
                        ),
                        weatherIcon(widget.conditon),
                        Text(
                          widget.temperature.round().toString() + '℃',
                          style: TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.bold,
                              color: neutral06),
                        ),
                        Text(
                          widget.conditon.name,
                          style: TextStyle(fontSize: 16, color: neutral06),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: neutral06,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16))),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            width: double.maxFinite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Waktu penyemprotan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                      'Waktu terbaik untuk menyemprot berdasarkan kondisi cuaca'),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 16),
                                  width: double.maxFinite,
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: weathers.length,
                                    itemBuilder: (context, index) {
                                      final Weather weather = weathers[index];
                                      return Container(
                                        margin: EdgeInsets.only(right: 12),
                                        width: 120,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            weather.weatherCondition ==
                                                    WeatherCondition.cerah
                                                ? Icon(Iconsax.close_circle)
                                                : Icon(Iconsax.tick_circle),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              DateFormat('HH:mm').format(
                                                  DateTime.parse(weather.time)),
                                              style:
                                                  TextStyle(color: neutral01),
                                            ),
                                            Text(
                                              weather.temperature.toString() +
                                                  '℃',
                                              style:
                                                  TextStyle(color: neutral01),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    'Keterangan',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Iconsax.close_circle),
                                      Text('Tidak menguntungkan'),
                                      Icon(Iconsax.tick_circle),
                                      Text('Optimal'),
                                    ],
                                  ),
                                )
                              ],
                            ),
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
      case WeatherCondition.cerah:
        return Icon(
          Iconsax.sun_1,
          size: 92,
          color: neutral06,
        );
      case WeatherCondition.berawan:
        return Icon(
          Iconsax.cloud_sunny,
          size: 92,
          color: neutral06,
        );
      case WeatherCondition.hujan:
        return Icon(
          Iconsax.cloud_drizzle,
          size: 92,
          color: neutral06,
        );
      case WeatherCondition.salju:
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
