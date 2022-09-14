import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../api/weather_api.dart';
import '../models/weather_forecast.dart';
import '../widgets/bottom_list_view.dart';
import '../widgets/city_view.dart';
import '../widgets/detail_view.dart';
import '../widgets/temp_view.dart';
import 'city_screen.dart';

class WeatherForecastScreen extends StatefulWidget {
  final WeatherForecast? locationWeather;
  const WeatherForecastScreen({Key? key, this.locationWeather})
      : super(key: key);

  @override
  WeatherForecastScreenState createState() => WeatherForecastScreenState();
}

class WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late Future<WeatherForecast> forecastObject =
      Future.value(widget.locationWeather);
  late String _cityName;

  @override
  void initState() {
    super.initState();
    forecastObject = Future.value(widget.locationWeather);

    if (widget.locationWeather != null) {
      forecastObject = Future.value(widget.locationWeather);
    }
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
              var tappedName = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const CityScreen();
              }));
              if (tappedName != null) {
                setState(() {
                  _cityName = tappedName;
                  forecastObject = WeatherApi()
                      .fetchWeatherForecast(cityName: _cityName, isCity: true);
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
              if (snapshot.connectionState != ConnectionState.done) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      SpinKitDoubleBounce(color: Colors.black87, size: 100.0),
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
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
                  child: Text(
                    'City not found\nPlease, enter correct city',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
