import 'city.dart';
import 'weather_list.dart';

class WeatherForecast {
  late City city;
  late String cod;
  late double message;
  late int cnt;
  List<WeatherList>? list;

  WeatherForecast({
    required this.city,
    required this.cod,
    required this.message,
    required this.cnt,
    this.list,
  });

  WeatherForecast.fromJson(Map<String, dynamic> json) {
    city = (json['city'] != null ? City.fromJson(json['city']) : null) as City;
    cod = json['cod'];
    message = json['message'];
    cnt = json['cnt'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(WeatherList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city.toJson();
    data['cod'] = cod;
    data['message'] = message;
    data['cnt'] = cnt;
    if (list != null) {
      data['list'] = list?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
