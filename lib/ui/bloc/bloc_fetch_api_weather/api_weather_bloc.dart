import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/weather_data.dart';
import '../../weather_service/weather_service.dart';

part 'api_weather_event.dart';
part 'api_weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final _weatherService = WeatherService();
  WeatherBloc() : super(WeatherInitialState()) {
    on<FetchWeatherEvent>((event, emit) async {
      String cityName = await _weatherService.getCurrentCity();
      try {
        final weather = await _weatherService.getWeather(cityName);
        emit(WeatherLoadedState(weatherData: weather));
      } catch (e) {
        emit(WeatherErrorState(errorMessage: 'Error: $e'));
      }
    });

  }
}


