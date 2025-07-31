import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/services/service_locator.dart';
import 'routing/app_router.dart';
import 'features/stammdaten/providers/refactored_klassen_provider.dart';
import 'features/stammdaten/providers/refactored_faecher_provider.dart';
import 'features/stammdaten/services/klassen_service.dart';
import 'features/stammdaten/services/faecher_service.dart';

class LehrerCockpitApp extends StatelessWidget {
  const LehrerCockpitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      mode: ServiceMode.mock, // Switch to SQLite later
      child: Builder(
        builder: (context) {
          // Get services from the ServiceProvider context
          final klassenService = context.read<KlassenService>();
          final faecherService = context.read<FaecherService>();
          
          return MultiProvider(
            providers: [
              // Direct service-based providers
              ChangeNotifierProvider(
                create: (_) => RefactoredKlassenProvider(klassenService),
              ),
              ChangeNotifierProvider(
                create: (_) => RefactoredFaecherProvider(faecherService),
              ),
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
        },
      ),
    );
  }
}
