
class WeatherData {
  final String cod;
  final int message;
  final int cnt;
  final List<ListTemp> list;
  final City city;

  WeatherData(
      {required this.cod,
      required this.message,
      required this.cnt,
      required this.list,
      required this.city,
      });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cod: json['cod'],
      message: json['message'],
      cnt: json['cnt'],
      city: City.fromJson(json['city']),
      list: (json['list'] as List)
          .map((item) => ListTemp.fromJson(item))
          .toList(),
    );
  }
}

class City {
  final String name;
  final String country;

  City({
    required this.name,
    required this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      country: json['country'],
    );
  }
}

class ListTemp {
  final Main main;
  final String dt_txt;
  final List<Weather> weatherList;

  ListTemp({
    required this.main,
    required this.dt_txt,
    required this.weatherList,
  });

  factory ListTemp.fromJson(Map<String, dynamic> json) {
    return ListTemp(
      main: Main.fromJson(json['main']),
      dt_txt: json['dt_txt'],
      weatherList: (json['weather'] as List)
          .map((item) => Weather.fromJson(item))
          .toList(),
    );
  }
}

class Main {
  final double temp;
  final double tempMin;
  final double tempMax;
  final double feelsLike;

  Main({
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.feelsLike,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
    );
  }
}

class Weather {
  final String icon;
  final String description;
  final String main;

  Weather({
    required this.icon,
    required this.description,
    required this.main,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      icon: json['icon'],
      description: json['description'],
      main: json['main'],
    );
  }
}