import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weatherappflutter/bloc/weather_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String getTimeOfDay(int timezoneOffset) {
    // Get the current UTC time
    DateTime now = DateTime.now().toUtc();

    // Apply the timezone offset
    DateTime localTime = now.add(Duration(seconds: timezoneOffset));

    // Determine the time of day
    int hour = localTime.hour;
    if (hour >= 6 && hour < 12) {
      return "Morning";
    } else if (hour >= 12 && hour < 18) {
      return "Afternoon";
    } else if (hour >= 18 && hour < 22) {
      return "Evening";
    } else {
      return "Night";
    }
  }

  Widget getWeatherIcon(int code) {
    print("getWeatherIcon- :${code}");

    if (code >= 200 && code < 300) {
      return Image.asset('assets/1.png');
    } else if (code >= 300 && code < 400) {
      return Image.asset('assets/2.png');
    } else if (code >= 500 && code < 600) {
      return Image.asset('assets/3.png');
    } else if (code >= 600 && code < 700) {
      return Image.asset('assets/4.png');
    } else if (code >= 700 && code < 800) {
      return Image.asset('assets/5.png');
    } else if (code == 800) {
      return Image.asset('assets/6.png');
    } else if (code > 800 && code < 804) {
      return Image.asset('assets/7.png');
    } else {
      return Image.asset('assets/1.png');
    }
  }


  Widget _buildWeatherInfo(String label, String value,
      {String assetPath = 'assets/11.png'}) {
    return Row(
      children: [
        Image.asset(assetPath, scale: 8),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w300)),
            const SizedBox(height: 3),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              const Align(
                alignment: AlignmentDirectional(3, -0.3),
                child: _ColoredCircle(size: 300, color: Colors.deepPurple),
              ),
              const Align(
                alignment: AlignmentDirectional(-3, -0.3),
                child: _ColoredCircle(size: 300, color: Colors.purple),
              ),
              const Align(
                alignment: AlignmentDirectional(0, -1.2),
                child: _ColoredCircle(size: 300, color: Colors.yellow),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.00),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherBlocSuccess) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "📍 ${state.weather.areaName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(height: 8),
                           Text(getTimeOfDay(18000),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          getWeatherIcon(state.weather.weatherConditionCode!),
                          Center(
                            child: Text(
                             "${state.weather.temperature?.celsius?.round()} °C",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 55,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Center(
                            child: Text(
                              (state.weather.weatherMain?.toUpperCase() ?? ""),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              DateFormat('EEEE dd *')
                                  .add_jm()
                                  .format(state.weather.date!),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildWeatherInfo(
                                "Sunrise",
                                DateFormat()
                                    .add_jm()
                                    .format(state.weather.sunrise!),
                                assetPath: 'assets/11.png',
                              ),
                              _buildWeatherInfo(
                                "Sunset",
                                DateFormat()
                                    .add_jm()
                                    .format(state.weather.sunset!),
                                assetPath: 'assets/12.png',
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Divider(color: Colors.grey),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildWeatherInfo(
                                "Temp Max",
                                "${state.weather.tempMax?.celsius?.round()} °C",
                                assetPath: 'assets/13.png',
                              ),
                              _buildWeatherInfo(
                                "Temp Min",
                                "${state.weather.tempMin?.celsius?.round()} °C",
                                assetPath: 'assets/14.png',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColoredCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _ColoredCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
