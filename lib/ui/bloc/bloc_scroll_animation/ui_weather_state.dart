part of 'ui_weather_bloc.dart';


class ScrollAnimationState {
  final double paddingVerticalText;
  final double fontSizeText;

  ScrollAnimationState(this.paddingVerticalText, this.fontSizeText);

  ScrollAnimationState copyWith(double paddingVerticalText, double fontSizeText) {
    return ScrollAnimationState(
      paddingVerticalText ?? this.paddingVerticalText,
      fontSizeText ?? this.fontSizeText,
    );
  }
}

