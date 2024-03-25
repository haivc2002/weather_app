import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/theme/theme_color.dart';
import 'package:weather_app/ui/bloc/bloc_fetch_api_weather/api_weather_bloc.dart';
import 'package:weather_app/ui/bloc/bloc_scroll_animation/ui_weather_bloc.dart';
import 'package:weather_app/ui/ui_weather.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/ui/weather_service/weather_service.dart';


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ScrollAnimationBloc()),
        BlocProvider(create: (context) => WeatherBloc()..add(FetchWeatherEvent())),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorPaletteProvider(
      themeColor: ThemeColor(),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_ , child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'First Method',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: child,
          );
        },
        child: const UIWeather(),
      ),
    );
  }
}
