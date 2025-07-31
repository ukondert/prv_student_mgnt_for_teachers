import 'package:flutter/foundation.dart';

import '../dtos/klasse_dtos.dart';
import '../services/klassen_service.dart';

/// Provider für Klassen-Management mit Service-Integration
/// 
/// Dieser Provider nutzt den abstrakten KlassenService für alle
/// Backend-Operationen und kann mit verschiedenen Service-Implementierungen
/// (Mock, SQLite, HTTP) arbeiten.
class RefactoredKlassenProvider with ChangeNotifier {
  final KlassenService _klassenService;
  
  List<KlasseResponse> _klassen = [];
  bool _isLoading = false;
  String? _error;

  RefactoredKlassenProvider(this._klassenService);

  // Getters
  List<KlasseResponse> get klassen => _klassen;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Aktive (nicht archivierte) Klassen
  List<KlasseResponse> get activeKlassen => 
      _klassen.where((k) => !k.istArchiviert).toList();

  /// Lade alle Klassen vom Service
  Future<void> loadKlassen({bool includeArchived = false}) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _klassenService.getAlleKlassen(
        includeArchived: includeArchived,
      );
      
      _klassen = response.klassen;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Erstelle eine neue Klasse
  Future<void> createKlasse(String name, String schuljahr) async {
    _clearError();
    
    try {
      final dto = KlasseCreateDto(name: name, schuljahr: schuljahr);
      final response = await _klassenService.klasseErstellen(dto);
      
      // Optimistic update: Add to local list
      _klassen.add(response);
      _sortKlassen();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Aktualisiere eine bestehende Klasse
  Future<void> updateKlasse(String id, {String? name, String? schuljahr}) async {
    _clearError();
    
    try {
      final dto = KlasseUpdateDto(name: name, schuljahr: schuljahr);
      final response = await _klassenService.klasseBearbeiten(id, dto);
      
      // Update local list
      final index = _klassen.indexWhere((k) => k.id == id);
      if (index != -1) {
        _klassen[index] = response;
        _sortKlassen();
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Archiviere eine Klasse
  Future<void> archiveKlasse(String id) async {
    _clearError();
    
    try {
      await _klassenService.klasseArchivieren(id);
      
      // Update local list
      final index = _klassen.indexWhere((k) => k.id == id);
      if (index != -1) {
        _klassen[index] = KlasseResponse(
          id: _klassen[index].id,
          name: _klassen[index].name,
          schuljahr: _klassen[index].schuljahr,
          erstelltAm: _klassen[index].erstelltAm,
          istArchiviert: true,
          schuelerAnzahl: _klassen[index].schuelerAnzahl,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Stelle eine archivierte Klasse wieder her
  Future<void> restoreKlasse(String id) async {
    _clearError();
    
    try {
      await _klassenService.klasseWiederherstellen(id);
      
      // Update local list
      final index = _klassen.indexWhere((k) => k.id == id);
      if (index != -1) {
        _klassen[index] = KlasseResponse(
          id: _klassen[index].id,
          name: _klassen[index].name,
          schuljahr: _klassen[index].schuljahr,
          erstelltAm: _klassen[index].erstelltAm,
          istArchiviert: false,
          schuelerAnzahl: _klassen[index].schuelerAnzahl,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Lösche eine Klasse permanent
  Future<void> deleteKlasse(String id, {bool force = false}) async {
    _clearError();
    
    try {
      await _klassenService.klasseLoeschen(id, force: force);
      
      // Remove from local list
      _klassen.removeWhere((k) => k.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Suche Klassen
  Future<void> searchKlassen({
    String? query,
    String? schuljahr,
    bool includeArchived = false,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _klassenService.sucheKlassen(
        query: query,
        schuljahr: schuljahr,
        includeArchived: includeArchived,
      );
      
      _klassen = response.klassen;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Lade alle verfügbaren Schuljahre
  Future<List<String>> loadSchuljahre() async {
    try {
      return await _klassenService.getAlleSchuljahre();
    } catch (e) {
      _setError(e.toString());
      return [];
    }
  }

  /// Refresh data (pull-to-refresh)
  Future<void> refresh({bool includeArchived = false}) async {
    await loadKlassen(includeArchived: includeArchived);
  }

  // Private helper methods
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  void _sortKlassen() {
    _klassen.sort((a, b) {
      final nameCompare = a.name.compareTo(b.name);
      if (nameCompare != 0) return nameCompare;
      return a.schuljahr.compareTo(b.schuljahr);
    });
  }

  /// Dispose resources
  @override
  void dispose() {
    super.dispose();
  }
}
