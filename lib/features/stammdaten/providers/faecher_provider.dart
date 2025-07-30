import 'package:flutter/foundation.dart';
import '../models/fach.dart';

class FaecherProvider extends ChangeNotifier {
  List<Fach> _faecher = [];
  bool _isLoading = false;

  List<Fach> get faecher => _faecher;
  bool get isLoading => _isLoading;

  /// Initialize with mock data
  Future<void> loadFaecher() async {
    _isLoading = true;
    notifyListeners();
    
    // Mock delay to simulate network request
    await Future.delayed(const Duration(milliseconds: 500));
    
    _faecher = [
      Fach(
        id: '1',
        name: 'Softwareentwicklung',
        kuerzel: 'SWE',
        klassenIds: ['6ba7b812-9dad-11d1-80b4-00c04fd430c8'],
        erstelltAm: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Fach(
        id: '2',
        name: 'Netzwerktechnik',
        kuerzel: 'NTVS',
        klassenIds: ['6ba7b812-9dad-11d1-80b4-00c04fd430c8', '6ba7b813-9dad-11d1-80b4-00c04fd430c8'],
        erstelltAm: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Fach(
        id: '3',
        name: 'Mathematik',
        kuerzel: 'M',
        klassenIds: ['1', '2', '3'],
        erstelltAm: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }

  /// Create a new fach
  Future<void> createFach(String name, String kuerzel, List<String> klassenIds) async {
    _isLoading = true;
    notifyListeners();
    
    // Mock network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newFach = Fach.neu(
      name: name,
      kuerzel: kuerzel,
      klassenIds: klassenIds,
    );
    
    _faecher.add(newFach);
    
    _isLoading = false;
    notifyListeners();
  }

  /// Update an existing fach
  Future<void> updateFach(String id, String name, String kuerzel, List<String> klassenIds) async {
    _isLoading = true;
    notifyListeners();
    
    // Mock network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    final index = _faecher.indexWhere((f) => f.id == id);
    if (index != -1) {
      _faecher[index] = _faecher[index].copyWith(
        name: name,
        kuerzel: kuerzel,
        klassenIds: klassenIds,
      );
    }
    
    _isLoading = false;
    notifyListeners();
  }

  /// Delete a fach
  Future<void> deleteFach(String id) async {
    _isLoading = true;
    notifyListeners();
    
    // Mock network delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    _faecher.removeWhere((f) => f.id == id);
    
    _isLoading = false;
    notifyListeners();
  }

  /// Get fach by ID
  Fach? getFachById(String id) {
    try {
      return _faecher.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a klasse to a fach
  Future<void> addKlasseToFach(String fachId, String klasseId) async {
    final fach = getFachById(fachId);
    if (fach != null && !fach.klassenIds.contains(klasseId)) {
      final updatedKlassenIds = [...fach.klassenIds, klasseId];
      await updateFach(fachId, fach.name, fach.kuerzel, updatedKlassenIds);
    }
  }

  /// Remove a klasse from a fach
  Future<void> removeKlasseFromFach(String fachId, String klasseId) async {
    final fach = getFachById(fachId);
    if (fach != null && fach.klassenIds.contains(klasseId)) {
      final updatedKlassenIds = fach.klassenIds.where((id) => id != klasseId).toList();
      await updateFach(fachId, fach.name, fach.kuerzel, updatedKlassenIds);
    }
  }

  /// Get all faecher for a specific klasse
  List<Fach> getFaecherForKlasse(String klasseId) {
    return _faecher.where((f) => f.klassenIds.contains(klasseId)).toList();
  }

  /// Get faecher statistics
  Map<String, int> getFaecherStats() {
    return {
      'total': _faecher.length,
      'withKlassen': _faecher.where((f) => f.klassenIds.isNotEmpty).length,
      'withoutKlassen': _faecher.where((f) => f.klassenIds.isEmpty).length,
    };
  }
}
