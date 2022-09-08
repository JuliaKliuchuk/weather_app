import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_app/screens/city_screen.dart';
import 'package:weather_app/widgets/city_view.dart';
import 'package:weather_app/widgets/temp_view.dart';

import '../api/weather_api.dart';
import '../models/weather_forecast.dart';
import '../widgets/bottom_list_view.dart';
import '../widgets/detail_view.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({Key? key}) : super(key: key);

  @override
  WeatherForecastScreenState createState() => WeatherForecastScreenState();
}

class WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late Future<WeatherForecast> forecastObject;
  String _cityName = 'London';

  @override
  void initState() {
    super.initState();

    forecastObject = WeatherApi().fetchWeatherForecast(cityName: _cityName);

    // forecastObject.then((weather) {
    //   print('in London -----${weather.list![0].weather[0].main}');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Weather forecast'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: () {
            setState(() {
              forecastObject = WeatherApi().fetchWeatherForecast();
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.location_city),
            onPressed: () async {
              var cityName = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const CityScreen();
              }));

              if (cityName != null) {
                setState(() {
                  _cityName = cityName;
                  forecastObject =
                      WeatherApi().fetchWeatherForecast(cityName: _cityName);
                });
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder<WeatherForecast>(
            future: forecastObject,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    const SizedBox(height: 50.0),
                    CityView(snapshot: snapshot),
                    const SizedBox(height: 50.0),
                    TempView(snapshot: snapshot),
                    const SizedBox(height: 50.0),
                    DetailView(snapshot: snapshot),
                    const SizedBox(height: 50.0),
                    BottomListView(snapshot: snapshot),
                  ],
                );
              } else {
                return const Center(
                    child: SpinKitDoubleBounce(
                  color: Colors.black,
                  size: 100.0,
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
