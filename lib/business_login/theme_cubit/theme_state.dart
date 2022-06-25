part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final bool? isLight;
  const ThemeState({this.isLight});

  ThemeState copyWith({bool? isLight}) {
    return ThemeState(isLight: isLight ?? this.isLight);
  }

  @override
  List<Object> get props => [isLight!];
}
