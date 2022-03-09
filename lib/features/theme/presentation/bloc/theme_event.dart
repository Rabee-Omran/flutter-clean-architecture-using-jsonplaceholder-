part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChangedEvent extends ThemeEvent {
  final AppTheme theme;

  ThemeChangedEvent({
    required this.theme,
  });

  @override
  List<Object> get props => [theme];
}

class InitialThemeEvent extends ThemeEvent {
  @override
  List<Object> get props => [];
}
