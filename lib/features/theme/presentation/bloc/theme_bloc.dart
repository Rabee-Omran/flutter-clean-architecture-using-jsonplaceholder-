import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/get_stored_theme.dart';
import '../../domain/usecases/store_theme.dart';
import '../../../../core/app_themes.dart';
import '../../../../core/usecases/usecase.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final StoreTheme storeTheme;
  final GetStoredTheme getStoredTheme;

  ThemeBloc({
    required this.storeTheme,
    required this.getStoredTheme,
  }) : super(
          ThemeLoadingState(),
        ) {
    on<ThemeEvent>((event, emit) async {
      if (event is ThemeChangedEvent) {
        final failureOrDone = await storeTheme(event.theme.index);

        emit(failureOrDone.fold(
          (_) => ThemeLoadedState(themeData: appThemeData[AppTheme.values[0]]!),
          (_) => ThemeLoadedState(themeData: appThemeData[event.theme]!),
        ));
      } else if (event is InitialThemeEvent) {
        final failureOrThemeIndex = await getStoredTheme(NoParams());

        emit(failureOrThemeIndex.fold(
          (_) => ThemeLoadedState(themeData: appThemeData[AppTheme.values[0]]!),
          (themeIndex) => ThemeLoadedState(
              themeData: appThemeData[AppTheme.values[themeIndex]]!),
        ));
      }
    });
  }
}
