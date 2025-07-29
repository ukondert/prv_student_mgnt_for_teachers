import 'package:go_router/go_router.dart';

import '../features/stammdaten/screens/klassen_screen.dart';
import '../features/stammdaten/screens/faecher_screen.dart';
import '../shared/widgets/app_layout.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/klassen',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/klassen',
            name: 'klassen',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: KlassenScreen(),
            ),
          ),
          GoRoute(
            path: '/faecher',
            name: 'faecher',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FaecherScreen(),
            ),
          ),
          // Weitere Routen werden hier hinzugefügt (Schüler, Bewertungen, etc.)
        ],
      ),
    ],
  );
}
