import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exception.dart';

abstract class ThemeLocalDataSource {
  Future<int> getStoredTheme();

  Future<bool> storedTheme(int themeIndex);
}

const CACHED_THEME_INDEX = 'CACHED_THEME_INDEX';

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<int> getStoredTheme() async {
    final themeIndex = sharedPreferences.getInt(CACHED_THEME_INDEX);

    if (themeIndex != null) {
      return Future.value(themeIndex);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> storedTheme(int themeIndex) async {
    await sharedPreferences.setInt(CACHED_THEME_INDEX, themeIndex);
    return Future.value(true);
  }
}
