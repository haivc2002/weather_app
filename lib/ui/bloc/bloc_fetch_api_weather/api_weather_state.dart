part of 'api_weather_bloc.dart';

abstract class WeatherState {}

class WeatherInitialState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  WeatherData? weatherData;

  WeatherLoadedState({required this.weatherData}) : super();

  List<Object?> get props => [weatherData];
}

class WeatherErrorState extends WeatherState {
  final String errorMessage;

  WeatherErrorState({required this.errorMessage});

  List<Object?> get props => [errorMessage];
}


