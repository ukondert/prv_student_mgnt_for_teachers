import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lehrer-Cockpit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Einstellungen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Einstellungen - Implementierung folgt'),
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Navigation (Desktop)
          if (MediaQuery.of(context).size.width > 800) ...[
            NavigationRail(
              selectedIndex: _getCurrentIndex(context),
              onDestinationSelected: (index) => _navigateToTab(context, index),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.class_),
                  label: Text('Klassen'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.subject),
                  label: Text('Fächer'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people),
                  label: Text('Schüler'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.assessment),
                  label: Text('Bewertung'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
          ],
          // Hauptinhalt
          Expanded(
            child: child,
          ),
        ],
      ),
      // Bottom Navigation (Mobile)
      bottomNavigationBar: MediaQuery.of(context).size.width <= 800
          ? NavigationBar(
              selectedIndex: _getCurrentIndex(context),
              onDestinationSelected: (index) => _navigateToTab(context, index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.class_),
                  label: 'Klassen',
                ),
                NavigationDestination(
                  icon: Icon(Icons.subject),
                  label: 'Fächer',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people),
                  label: 'Schüler',
                ),
                NavigationDestination(
                  icon: Icon(Icons.assessment),
                  label: 'Bewertung',
                ),
              ],
            )
          : null,
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouter.of(context).routeInformationProvider.value.location;
    switch (location) {
      case '/klassen':
        return 0;
      case '/faecher':
        return 1;
      case '/schueler':
        return 2;
      case '/bewertung':
        return 3;
      default:
        return 0;
    }
  }

  void _navigateToTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/klassen');
        break;
      case 1:
        context.go('/faecher');
        break;
      case 2:
        // TODO: Schüler-Route implementieren
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Schüler-Verwaltung - Implementierung folgt'),
          ),
        );
        break;
      case 3:
        // TODO: Bewertungs-Route implementieren
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bewertungs-System - Implementierung folgt'),
          ),
        );
        break;
    }
  }
}
