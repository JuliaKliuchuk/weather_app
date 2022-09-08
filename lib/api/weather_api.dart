import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/weather_forecast.dart';
import '../utilites/constants.dart';
import '../utilites/location.dart';

class WeatherApi {
  Future<WeatherForecast> fetchWeatherForecast(
      {String? cityName, bool? isCity}) async {
    Location location = Location();
    await location.getCurrentLocation();
    Map<String, String?> params;

    if (isCity == true) {
      var queryParams = {
        'appid': Constants.WEATHER_APP_ID,
        'units': 'metric',
        'q': cityName
      };
      params = queryParams;
    } else {
      var queryParams = {
        'appid': Constants.WEATHER_APP_ID,
        'units': 'metric',
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
      };
      params = queryParams;
    }

    var uri = Uri.https(Constants.WEATHER_BASE_URL_DOMAIN,
        Constants.WEATHER_FORECAST_PATH, params);

    log('request --- ${uri.toString()}');

    var response = await http.get(uri);
    log('response --- ${response.body}');

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error respose');
    }
  }
}
