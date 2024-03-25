import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../model/weather_data.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const apiWeather = 'http://api.openweathermap.org/data/2.5/forecast';

  WeatherService();

  Future<WeatherData> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$apiWeather?q=$cityName&appid=73b98a624e753eb0f014eb5118e8e3b9&units=metric'));
    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].administrativeArea?.trim();

    return city ?? "";
  }
}