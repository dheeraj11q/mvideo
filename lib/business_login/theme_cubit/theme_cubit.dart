import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(isLight: true));

  void themeChange() {
    if (state.isLight!) {
      emit(state.copyWith(isLight: false));
    } else {
      emit(state.copyWith(isLight: true));
    }
  }
}
