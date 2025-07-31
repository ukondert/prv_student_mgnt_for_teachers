import 'package:flutter/foundation.dart';

import '../dtos/fach_dtos.dart';
import '../services/faecher_service.dart';

/// Provider für Fächer-Management mit Service-Integration
/// 
/// Dieser Provider nutzt den abstrakten FaecherService für alle
/// Backend-Operationen und kann mit verschiedenen Service-Implementierungen
/// (Mock, SQLite, HTTP) arbeiten.
class RefactoredFaecherProvider with ChangeNotifier {
  final FaecherService _faecherService;
  
  List<FachResponse> _faecher = [];
  bool _isLoading = false;
  String? _error;

  RefactoredFaecherProvider(this._faecherService);

  // Getters
  List<FachResponse> get faecher => _faecher;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Lade alle Fächer vom Service
  Future<void> loadFaecher({bool includeKlassenInfo = true}) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _faecherService.getAlleFaecher(
        includeKlassenInfo: includeKlassenInfo,
      );
      
      _faecher = response.faecher;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Erstelle ein neues Fach
  Future<void> createFach(String name, String kuerzel, {List<String> klassenIds = const []}) async {
    _clearError();
    
    try {
      final dto = FachCreateDto(name: name, kuerzel: kuerzel, klassenIds: klassenIds);
      final response = await _faecherService.fachErstellen(dto);
      
      // Optimistic update: Add to local list
      _faecher.add(response);
      _sortFaecher();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Aktualisiere ein bestehendes Fach
  Future<void> updateFach(String id, {String? name, String? kuerzel, List<String>? klassenIds}) async {
    _clearError();
    
    try {
      final dto = FachUpdateDto(name: name, kuerzel: kuerzel, klassenIds: klassenIds);
      final response = await _faecherService.fachBearbeiten(id, dto);
      
      // Update local list
      final index = _faecher.indexWhere((f) => f.id == id);
      if (index != -1) {
        _faecher[index] = response;
        _sortFaecher();
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Lösche ein Fach
  Future<void> deleteFach(String id, {bool force = false}) async {
    _clearError();
    
    try {
      await _faecherService.fachLoeschen(id, force: force);
      
      // Remove from local list
      _faecher.removeWhere((f) => f.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Ordne eine Klasse einem Fach zu
  Future<void> assignKlasseToFach(String fachId, String klasseId) async {
    _clearError();
    
    try {
      await _faecherService.klasseFachZuordnen(fachId, klasseId);
      
      // Update local list
      final index = _faecher.indexWhere((f) => f.id == fachId);
      if (index != -1) {
        final fach = _faecher[index];
        if (!fach.klassenIds.contains(klasseId)) {
          _faecher[index] = FachResponse(
            id: fach.id,
            name: fach.name,
            kuerzel: fach.kuerzel,
            klassenIds: [...fach.klassenIds, klasseId],
            erstelltAm: fach.erstelltAm,
            zugeordneteKlassen: fach.zugeordneteKlassen,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Entferne eine Klasse von einem Fach
  Future<void> removeKlasseFromFach(String fachId, String klasseId) async {
    _clearError();
    
    try {
      await _faecherService.klasseFachEntfernen(fachId, klasseId);
      
      // Update local list
      final index = _faecher.indexWhere((f) => f.id == fachId);
      if (index != -1) {
        final fach = _faecher[index];
        final updatedKlassenIds = fach.klassenIds.where((id) => id != klasseId).toList();
        _faecher[index] = FachResponse(
          id: fach.id,
          name: fach.name,
          kuerzel: fach.kuerzel,
          klassenIds: updatedKlassenIds,
          erstelltAm: fach.erstelltAm,
          zugeordneteKlassen: fach.zugeordneteKlassen,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Batch-Zuordnung von Klassen zu einem Fach
  Future<void> assignKlassenToFach(String fachId, List<String> klassenIds, {bool replaceExisting = false}) async {
    _clearError();
    
    try {
      await _faecherService.batchKlassenZuordnen(fachId, klassenIds, replaceExisting: replaceExisting);
      
      // Update local list
      final index = _faecher.indexWhere((f) => f.id == fachId);
      if (index != -1) {
        final fach = _faecher[index];
        List<String> newKlassenIds;
        
        if (replaceExisting) {
          newKlassenIds = klassenIds.toList();
        } else {
          newKlassenIds = [...fach.klassenIds];
          for (final klasseId in klassenIds) {
            if (!newKlassenIds.contains(klasseId)) {
              newKlassenIds.add(klasseId);
            }
          }
        }
        
        _faecher[index] = FachResponse(
          id: fach.id,
          name: fach.name,
          kuerzel: fach.kuerzel,
          klassenIds: newKlassenIds,
          erstelltAm: fach.erstelltAm,
          zugeordneteKlassen: fach.zugeordneteKlassen,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  /// Suche Fächer
  Future<void> searchFaecher({
    String? query,
    String? klasseId,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _faecherService.sucheFaecher(
        query: query,
        klasseId: klasseId,
      );
      
      _faecher = response.faecher;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Lade alle verfügbaren Kürzel
  Future<List<String>> loadKuerzel() async {
    try {
      return await _faecherService.getAlleKuerzel();
    } catch (e) {
      _setError(e.toString());
      return [];
    }
  }

  /// Prüfe ob ein Kürzel verfügbar ist
  Future<bool> isKuerzelAvailable(String kuerzel, {String? excludeFachId}) async {
    try {
      return await _faecherService.istKuerzelVerfuegbar(kuerzel, excludeFachId: excludeFachId);
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Refresh data (pull-to-refresh)
  Future<void> refresh({bool includeKlassenInfo = true}) async {
    await loadFaecher(includeKlassenInfo: includeKlassenInfo);
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

  void _sortFaecher() {
    _faecher.sort((a, b) => a.name.compareTo(b.name));
  }

  /// Dispose resources
  @override
  void dispose() {
    super.dispose();
  }
}
