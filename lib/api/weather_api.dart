import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/weather_forecast.dart';
import '../utilites/constants.dart';

class WeatherApi {
  Future<WeatherForecast> fetchWeatherForecast({String? cityName}) async {
    var queryParams = {
      'APPID': Constants.WEATHER_APP_ID,
      'units': 'metric',
      'q': cityName,
    };

    var uri = Uri.https(Constants.WEATHER_BASE_URL_DOMAIN,
        Constants.WEATHER_FORECAST_PATH, queryParams);

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
