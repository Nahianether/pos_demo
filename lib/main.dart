import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/database_service.dart';
import 'services/initial_data_service.dart';
import 'screens/pos_screen_riverpod.dart';
import 'providers/theme_provider.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set landscape orientation only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await DatabaseService.init();

  // Load initial realistic data (force reload to clear old data)
  // Set forceReload to false after first successful load
  await InitialDataService.initializeData(forceReload: true);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'POS System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const POSScreenRiverpod(),
    );
  }
}
