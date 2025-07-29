import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';
import 'features/stammdaten/providers/klassen_provider.dart';
import 'features/stammdaten/providers/faecher_provider.dart';

class LehrerCockpitApp extends StatelessWidget {
  const LehrerCockpitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KlassenProvider()),
        ChangeNotifierProvider(create: (_) => FaecherProvider()),
      ],
      child: MaterialApp.router(
        title: 'Lehrer-Cockpit',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
