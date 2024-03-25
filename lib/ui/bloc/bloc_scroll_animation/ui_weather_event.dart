part of 'ui_weather_bloc.dart';

abstract class ScrollAnimationEvent {}

class ScrollEvent extends ScrollAnimationEvent {
  final double extent;
  final double maxExtent;
  final double minExtent;

  ScrollEvent(this.extent, this.maxExtent, this.minExtent);
}