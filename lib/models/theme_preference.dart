import 'package:hive/hive.dart';

part 'theme_preference.g.dart';

@HiveType(typeId: 3)
enum AppThemeMode {
  @HiveField(0)
  light,

  @HiveField(1)
  dark,

  @HiveField(2)
  system,
}

@HiveType(typeId: 4)
class ThemePreference extends HiveObject {
  @HiveField(0)
  AppThemeMode themeMode;

  @HiveField(1)
  DateTime lastUpdated;

  ThemePreference({
    this.themeMode = AppThemeMode.light,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
}
