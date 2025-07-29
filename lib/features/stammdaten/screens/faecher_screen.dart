import 'package:flutter/material.dart';

class FaecherScreen extends StatelessWidget {
  const FaecherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.subject,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Fächer-Verwaltung',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Implementierung folgt in TASK-009',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Neues Fach Dialog öffnen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Neues Fach - Implementierung folgt'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
