import 'package:flutter/foundation.dart';

import '../models/klasse.dart';

class KlassenProvider with ChangeNotifier {
  List<Klasse> _klassen = [];
  bool _isLoading = false;
  String? _error;

  List<Klasse> get klassen => _klassen;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Aktive (nicht archivierte) Klassen
  List<Klasse> get activeKlassen => _klassen.where((k) => !k.istArchiviert).toList();

  // TODO: Implementierung folgt in TASK-005 (Service Integration)
  Future<void> loadKlassen() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Mock delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock-Daten für UI-Testing mit echten UUIDs
      _klassen = [
        Klasse(
          id: 'f47ac10b-58cc-4372-a567-0e02b2c3d479',
          name: '4AHITS',
          schuljahr: '2024/25',
          erstelltAm: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Klasse(
          id: '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
          name: '3BHITS',
          schuljahr: '2024/25',
          erstelltAm: DateTime.now().subtract(const Duration(days: 25)),
        ),
        Klasse(
          id: '6ba7b811-9dad-11d1-80b4-00c04fd430c8',
          name: '5AHET',
          schuljahr: '2024/25',
          erstelltAm: DateTime.now().subtract(const Duration(days: 20)),
        ),
        Klasse(
          id: '6ba7b812-9dad-11d1-80b4-00c04fd430c8',
          name: '2AMIT',
          schuljahr: '2024/25',
          erstelltAm: DateTime.now().subtract(const Duration(days: 15)),
        ),
        Klasse(
          id: '6ba7b813-9dad-11d1-80b4-00c04fd430c8',
          name: '1AHITS',
          schuljahr: '2024/25',
          erstelltAm: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ];
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Neue Klasse erstellen
  Future<void> createKlasse(Klasse klasse) async {
    try {
      // TODO: Backend-Service aufrufen
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Validierung: Duplikate verhindern
      if (_klassen.any((k) => k.name.toLowerCase() == klasse.name.toLowerCase() && 
                             k.schuljahr == klasse.schuljahr)) {
        throw Exception('Eine Klasse mit diesem Namen existiert bereits im Schuljahr ${klasse.schuljahr}');
      }
      
      _klassen.add(klasse);
      _sortKlassen();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Klasse aktualisieren
  Future<void> updateKlasse(Klasse updatedKlasse) async {
    try {
      // TODO: Backend-Service aufrufen
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _klassen.indexWhere((k) => k.id == updatedKlasse.id);
      if (index != -1) {
        _klassen[index] = updatedKlasse;
        _sortKlassen();
        notifyListeners();
      } else {
        throw Exception('Klasse nicht gefunden');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Klasse löschen (soft delete - archivieren)
  Future<void> deleteKlasse(String klasseId) async {
    try {
      // TODO: Backend-Service aufrufen
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _klassen.indexWhere((k) => k.id == klasseId);
      if (index != -1) {
        final klasse = _klassen[index];
        _klassen[index] = klasse.copyWith(istArchiviert: true);
        notifyListeners();
      } else {
        throw Exception('Klasse nicht gefunden');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Klasse dauerhaft löschen
  Future<void> permanentDeleteKlasse(String klasseId) async {
    try {
      // TODO: Backend-Service aufrufen
      await Future.delayed(const Duration(milliseconds: 300));
      
      _klassen.removeWhere((k) => k.id == klasseId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Klasse wiederherstellen
  Future<void> restoreKlasse(String klasseId) async {
    try {
      // TODO: Backend-Service aufrufen
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _klassen.indexWhere((k) => k.id == klasseId);
      if (index != -1) {
        final klasse = _klassen[index];
        _klassen[index] = klasse.copyWith(istArchiviert: false);
        notifyListeners();
      } else {
        throw Exception('Klasse nicht gefunden');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Klassen sortieren (nach Schuljahr, dann nach Name)
  void _sortKlassen() {
    _klassen.sort((a, b) {
      final schuljahrComparison = b.schuljahr.compareTo(a.schuljahr); // Neueste zuerst
      if (schuljahrComparison != 0) return schuljahrComparison;
      return a.name.compareTo(b.name); // Dann alphabetisch
    });
  }

  // Hilfsmethoden für UI
  List<String> getSchuljahre() {
    return _klassen.map((k) => k.schuljahr).toSet().toList()
      ..sort((a, b) => b.compareTo(a)); // Neueste zuerst
  }

  List<Klasse> getKlassenBySchuljahr(String schuljahr) {
    return _klassen.where((k) => k.schuljahr == schuljahr && !k.istArchiviert).toList();
  }

  Klasse? getKlasseById(String id) {
    try {
      return _klassen.firstWhere((k) => k.id == id);
    } catch (e) {
      return null;
    }
  }

  // Suche und Filter
  List<Klasse> searchKlassen(String query) {
    if (query.isEmpty) return activeKlassen;
    
    final lowerQuery = query.toLowerCase();
    return activeKlassen.where((klasse) {
      return klasse.name.toLowerCase().contains(lowerQuery) ||
             klasse.schuljahr.contains(lowerQuery);
    }).toList();
  }
}
