import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../api/weather_api.dart';
import '../models/weather_forecast.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({Key? key}) : super(key: key);

  @override
  WeatherForecastScreenState createState() => WeatherForecastScreenState();
}

class WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late Future<WeatherForecast> forecastObject;
  late String _cityName = 'London';

  @override
  void initState() {
    super.initState();

    forecastObject = WeatherApi().fetchWeatherForecast(cityName: _cityName);

    forecastObject.then((weather) {
      print('in London -----${weather.list![0].weather[0].main}');
    });
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
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: FutureBuilder<WeatherForecast>(
              future: forecastObject,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const Center(child: Text('OK'));
                } else {
                  return const Center(
                      child: SpinKitDoubleBounce(
                    color: Colors.black,
                    size: 100.0,
                  ));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
