import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather_data.dart';
import 'package:weather_app/theme/theme_color.dart';
import 'package:weather_app/ui/weather_service/weather_service.dart';
import 'bloc/bloc_fetch_api_weather/api_weather_bloc.dart';
import 'bloc/bloc_scroll_animation/ui_weather_bloc.dart';

class UIWeather extends StatefulWidget {
  const UIWeather({Key? key}) : super(key: key);

  @override
  State<UIWeather> createState() => _UIWeatherState();
}

class _UIWeatherState extends State<UIWeather> {
  @override
  void initState() {
    super.initState();
    context.read<WeatherBloc>().add(FetchWeatherEvent());
  }

  String formatDateTime(String? dateTimeString) {
    try {
      if (dateTimeString != null && dateTimeString.isNotEmpty) {
        DateTime dateTime = DateTime.parse(dateTimeString);
        DateFormat formatter = DateFormat('HH:mm');
        String formattedTime = formatter.format(dateTime);
        return formattedTime;
      } else {
        return '__:__';
      }
    } catch (e) {
      print(e);
      return '__:__';
    }
  }

  String getBackgroundImage(WeatherData? weatherData) {
    if (weatherData != null && weatherData.list.isNotEmpty) {
      final String? main = weatherData.list[0].weatherList.isNotEmpty ? weatherData.list[0].weatherList[0].main : null;
      final double temp = weatherData.list[0].main.temp;
      DateTime now = DateTime.now();
      int hour = now.hour;

      if (main == 'Rain') {
        return 'assets/rain.png';
      } else if (main == 'Clouds') {
        if (temp < 13) {
          return 'assets/cold.png';
        } else {
          if (hour >= 6 && hour < 12) {
            return 'assets/sunny.png';
          } else if (hour >= 12 && hour < 18) {
            return 'assets/afternoon.png';
          } else {
            return 'assets/night.png';
          }
        }
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ScrollAnimationBloc, ScrollAnimationState>(
        builder: (context, scrollState) {
          return Stack(
            children: [
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if(state is WeatherInitialState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is WeatherLoadedState) {
                    return Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(getBackgroundImage(state.weatherData)),
                              fit: BoxFit.cover
                          )
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          BlocBuilder<WeatherBloc, WeatherState>(
                              builder: (context, wState) {
                                return formTempNow(context, scrollState, wState);
                              }
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }
              ),

              NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  context.read<ScrollAnimationBloc>().add(ScrollEvent(notification.extent, notification.maxExtent, notification.minExtent));
                  return true;
                },
                child: DraggableScrollableSheet(
                  minChildSize: 0.5,
                  maxChildSize: 0.8,
                  initialChildSize: 0.5,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, ),
                        child: BlocBuilder<WeatherBloc, WeatherState>(
                          builder: (context, wState) {
                            return Column(
                              children: [
                                forecastForTheDay(context, wState),
                                listTomorrow(scrollController, context, wState)
                              ],
                            );
                          }
                        )
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget formTempNow(BuildContext context, ScrollAnimationState scrollState, WeatherState wState) {
    if(wState is WeatherInitialState) {
      return const Center(
        child: Text('loadding...', style: TextStyle(color: ThemeColor.whiteColor)),
      );
    } else if (wState is WeatherLoadedState) {
      final data = wState.weatherData?.list[0];
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: scrollState.paddingVerticalText.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text('${data?.main.temp.round()}°C', style: TextStyle(fontSize: scrollState.fontSizeText.sp, color: ThemeColor.whiteColor),),
                  SizedBox(width: 20.w,),
                  if (wState.weatherData != null && wState.weatherData!.list.isNotEmpty)
                    Column(
                      children: [
                        Text('H : ${data?.main.tempMax.round()}°', style: TextStyle(fontSize: 12.sp, color: ThemeColor.whiteColor),),
                        Text('L : ${data?.main.tempMin.round()}°', style: TextStyle(fontSize: 12.sp, color: ThemeColor.whiteColor),),
                      ],
                    )
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_sharp,
                    color: ThemeColor.whiteColor,
                  ),
                  Text('${wState.weatherData?.city.name ?? "loading ..."}, ${wState.weatherData?.city.country ?? ""}',
                    style: TextStyle(
                        color: ThemeColor.whiteColor,
                        fontSize: 12.sp
                    ),
                  ),
                ],
              )
            ],
          )
      );
    } else {
      return Container();
    }
  }

  Widget forecastForTheDay(BuildContext context, WeatherState wState) {
    if(wState is WeatherInitialState) {
      return const Center(
        child: Text('loading...'),
      );
    } else if (wState is WeatherLoadedState) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: ThemeColor.whiteColor.withOpacity(1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Low of ${wState.weatherData?.list[0].main.temp.round()} degrees, ${wState.weatherData?.list[0].weatherList[0].description ?? "__"}.', style: TextStyle(fontSize: 12.sp),),
                ),
                SizedBox(
                  height: 100.h,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Column(
                              children: [
                                Text(formatDateTime(wState.weatherData?.list[index].dt_txt ?? ""),
                                  style: TextStyle(
                                      fontSize: 8.sp
                                  ),),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage('https://openweathermap.org/img/wn/${wState.weatherData?.list[index].weatherList[0].icon}@2x.png')
                                      )
                                  ),
                                ),
                                Text('${wState.weatherData?.list[index].main.temp.round()}°',
                                  style: TextStyle(
                                      fontSize: 10.sp
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  final List<String> weekDays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  int currentWeekday = DateTime.now().weekday;

  Widget listTomorrow(scrollController, BuildContext context, WeatherState wState) {
    if(wState is WeatherInitialState) {
      return const Center(
        child: Text('loading...'),
      );
    } else if (wState is WeatherLoadedState) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColor.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text('Tomorrow\'s temperature', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400)),
                  Text('Almost equal to today', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: (wState.weatherData?.list.length ?? 0),
            itemBuilder: (context, index) {
              int targetIndex = (index * 8);
              if (wState.weatherData?.list != null && targetIndex < wState.weatherData!.list.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Text(weekDays[index], style: TextStyle(fontSize: 12.sp),),
                      const Spacer(),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: wState.weatherData!.list[index].weatherList.isNotEmpty ?
                        BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage('https://openweathermap.org/img/wn/${wState.weatherData?.list[index].weatherList[0].icon}@2x.png')
                          ),
                        )
                            : null,
                      ),
                      SizedBox(width: 40.w,),
                      Text('${wState.weatherData?.list[index*8].main.tempMax.round()}°', style: TextStyle(fontSize: 12.sp),),
                      SizedBox(width: 10.w,),
                      Text('${wState.weatherData?.list[index*8].main.tempMin.round()}°', style: TextStyle(fontSize: 12.sp),),
                      SizedBox(width: 20.w,)
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }

}
