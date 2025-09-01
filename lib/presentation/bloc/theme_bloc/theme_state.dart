part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  final bool isDark;

  const ThemeState(this.isDark);

  @override
  List<Object> get props => [isDark];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(false);
}

class ThemeLoaded extends ThemeState {
  const ThemeLoaded(super.isDark);
}