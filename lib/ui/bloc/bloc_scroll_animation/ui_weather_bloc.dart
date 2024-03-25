import 'package:flutter_bloc/flutter_bloc.dart';

part 'ui_weather_event.dart';
part 'ui_weather_state.dart';

class ScrollAnimationBloc extends Bloc<ScrollAnimationEvent, ScrollAnimationState> {
  ScrollAnimationBloc() : super(ScrollAnimationState(100, 45)) {
    on<ScrollEvent>((event, emit) {
      double percentage = (event.extent - event.minExtent) / (event.maxExtent - event.minExtent);
      double paddingVerticalText = 100 - (50 * percentage);
      double fontSizeText = 45 - (15 * percentage);
      emit(state.copyWith(paddingVerticalText, fontSizeText));
    });
  }
}
