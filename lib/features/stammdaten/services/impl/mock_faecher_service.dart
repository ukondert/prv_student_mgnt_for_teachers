import '../faecher_service.dart';
import '../../models/fach.dart';
import '../../dtos/fach_dtos.dart';

/// MockUp-Server-Implementierung für FaecherService
/// 
/// Diese Implementierung simuliert einen Backend-Server mit In-Memory-Daten.
/// Sie kann später durch eine SQLite- oder HTTP-API-Implementierung ersetzt werden.
/// 
/// Features:
/// - Realistische Latenz-Simulation
/// - Validierung und Error-Handling
/// - Vollständige CRUD-Operationen
/// - Fach-Klassen-Zuordnung
/// - Robuste Duplikat-Erkennung
class MockFaecherService implements FaecherService {
  // In-Memory Database simulation
  static final Map<String, Fach> _database = {};
  static bool _isInitialized = false;

  /// Initialize mock data if not already done
  static Future<void> _initializeMockData() async {
    if (_isInitialized) return;

    // Realistic mock data with proper UUIDs
    final mockFaecher = [
      Fach(
        id: 'fach-swe-uuid-1234',
        name: 'Softwareentwicklung',
        kuerzel: 'SWE',
        klassenIds: ['6ba7b812-9dad-11d1-80b4-00c04fd430c8'], // 2AMIT
        erstelltAm: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Fach(
        id: 'fach-ntvs-uuid-5678',
        name: 'Netzwerktechnik',
        kuerzel: 'NTVS',
        klassenIds: [
          '6ba7b812-9dad-11d1-80b4-00c04fd430c8', // 2AMIT
          '6ba7b813-9dad-11d1-80b4-00c04fd430c8', // 1AHITS
        ],
        erstelltAm: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Fach(
        id: 'fach-math-uuid-9012',
        name: 'Mathematik',
        kuerzel: 'M',
        klassenIds: [
          'f47ac10b-58cc-4372-a567-0e02b2c3d479', // 4AHITS
          '6ba7b810-9dad-11d1-80b4-00c04fd430c8', // 3BHITS
          '6ba7b811-9dad-11d1-80b4-00c04fd430c8', // 5AHET
        ],
        erstelltAm: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    for (final fach in mockFaecher) {
      _database[fach.id] = fach;
    }

    _isInitialized = true;
  }

  /// Simulate realistic network latency
  Future<void> _simulateLatency([int? customMs]) async {
    final latency = customMs ?? (150 + (DateTime.now().millisecond % 350)); // 150-500ms
    await Future.delayed(Duration(milliseconds: latency));
  }

  @override
  Future<FaecherListResponse> getAlleFaecher({
    int page = 1,
    int pageSize = 20,
    bool includeKlassenInfo = true,
  }) async {
    await _initializeMockData();
    await _simulateLatency();

    // Validate parameters
    if (page < 1) throw ArgumentError('Page must be >= 1');
    if (pageSize < 1 || pageSize > 100) throw ArgumentError('PageSize must be between 1 and 100');

    // Get and sort
    var faecher = _database.values.toList();
    faecher.sort((a, b) => a.name.compareTo(b.name));

    // Apply pagination
    final totalCount = faecher.length;
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalCount);
    
    final paginatedFaecher = faecher.sublist(
      startIndex.clamp(0, totalCount),
      endIndex,
    );

    return FaecherListResponse(
      faecher: paginatedFaecher.map((f) => FachMapper.toResponse(f)).toList(),
      total: totalCount,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<FachResponse> getFachById(String id, {bool includeKlassenInfo = true}) async {
    await _initializeMockData();
    await _simulateLatency();

    final fach = _database[id];
    if (fach == null) {
      throw FachNotFoundException('Fach mit ID $id nicht gefunden');
    }

    return FachMapper.toResponse(fach);
  }

  @override
  Future<FachResponse> fachErstellen(FachCreateDto dto) async {
    await _initializeMockData();
    await _simulateLatency();

    // Validation
    if (dto.name.trim().isEmpty) {
      throw FachValidationException('Fachname darf nicht leer sein');
    }
    
    if (dto.kuerzel.trim().isEmpty) {
      throw FachValidationException('Fachkürzel darf nicht leer sein');
    }

    // Check for duplicates
    final duplicateName = _database.values.any((f) => 
      f.name.toLowerCase() == dto.name.toLowerCase()
    );
    
    if (duplicateName) {
      throw FachValidationException(
        'Ein Fach mit dem Namen "${dto.name}" existiert bereits'
      );
    }

    final duplicateKuerzel = _database.values.any((f) => 
      f.kuerzel.toLowerCase() == dto.kuerzel.toLowerCase()
    );
    
    if (duplicateKuerzel) {
      throw FachValidationException(
        'Ein Fach mit dem Kürzel "${dto.kuerzel}" existiert bereits'
      );
    }

    // Create new Fach
    final fach = Fach.neu(
      name: dto.name.trim(),
      kuerzel: dto.kuerzel.trim(),
      klassenIds: dto.klassenIds,
    );

    _database[fach.id] = fach;

    return FachMapper.toResponse(fach);
  }

  @override
  Future<FachResponse> fachBearbeiten(String id, FachUpdateDto dto) async {
    await _initializeMockData();
    await _simulateLatency();

    final existingFach = _database[id];
    if (existingFach == null) {
      throw FachNotFoundException('Fach mit ID $id nicht gefunden');
    }

    // Validation
    if (dto.name != null && dto.name!.trim().isEmpty) {
      throw FachValidationException('Fachname darf nicht leer sein');
    }
    
    if (dto.kuerzel != null && dto.kuerzel!.trim().isEmpty) {
      throw FachValidationException('Fachkürzel darf nicht leer sein');
    }

    // Check for duplicates (excluding current record)
    if (dto.name != null) {
      final duplicateName = _database.values.any((f) => 
        f.id != id && f.name.toLowerCase() == dto.name!.toLowerCase()
      );
      
      if (duplicateName) {
        throw FachValidationException(
          'Ein Fach mit dem Namen "${dto.name}" existiert bereits'
        );
      }
    }

    if (dto.kuerzel != null) {
      final duplicateKuerzel = _database.values.any((f) => 
        f.id != id && f.kuerzel.toLowerCase() == dto.kuerzel!.toLowerCase()
      );
      
      if (duplicateKuerzel) {
        throw FachValidationException(
          'Ein Fach mit dem Kürzel "${dto.kuerzel}" existiert bereits'
        );
      }
    }

    // Update Fach
    final updatedFach = existingFach.copyWith(
      name: dto.name?.trim(),
      kuerzel: dto.kuerzel?.trim(),
      klassenIds: dto.klassenIds,
    );

    _database[id] = updatedFach;

    return FachMapper.toResponse(updatedFach);
  }

  @override
  Future<void> fachLoeschen(String id, {bool force = false}) async {
    await _initializeMockData();
    await _simulateLatency();

    if (!_database.containsKey(id)) {
      throw FachNotFoundException('Fach mit ID $id nicht gefunden');
    }

    // In a real implementation, check for grades here
    // For now, we just delete directly
    _database.remove(id);
  }

  @override
  Future<void> klasseFachZuordnen(String fachId, String klasseId) async {
    await _initializeMockData();
    await _simulateLatency();

    final fach = _database[fachId];
    if (fach == null) {
      throw FachNotFoundException(fachId);
    }

    if (!fach.klassenIds.contains(klasseId)) {
      final updatedFach = fach.copyWith(
        klassenIds: [...fach.klassenIds, klasseId],
      );
      _database[fachId] = updatedFach;
    }
  }

  @override
  Future<void> klasseFachEntfernen(String fachId, String klasseId) async {
    await _initializeMockData();
    await _simulateLatency();

    final fach = _database[fachId];
    if (fach == null) {
      throw FachNotFoundException(fachId);
    }

    final updatedKlassenIds = fach.klassenIds.where((id) => id != klasseId).toList();
    final updatedFach = fach.copyWith(klassenIds: updatedKlassenIds);
    _database[fachId] = updatedFach;
  }

  @override
  Future<void> batchKlassenZuordnen(String fachId, List<String> klassenIds, {bool replaceExisting = false}) async {
    await _initializeMockData();
    await _simulateLatency();

    final fach = _database[fachId];
    if (fach == null) {
      throw FachNotFoundException(fachId);
    }

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

    final updatedFach = fach.copyWith(klassenIds: newKlassenIds);
    _database[fachId] = updatedFach;
  }

  @override
  Future<FaecherListResponse> sucheFaecher({
    String? query,
    String? klasseId,
    int page = 1,
    int pageSize = 20,
  }) async {
    await _initializeMockData();
    await _simulateLatency();

    // Start with all faecher
    var faecher = _database.values.toList();
    
    // Apply filters
    if (query != null && query.trim().isNotEmpty) {
      final searchTerm = query.toLowerCase();
      faecher = faecher.where((f) => 
        f.name.toLowerCase().contains(searchTerm) ||
        f.kuerzel.toLowerCase().contains(searchTerm)
      ).toList();
    }
    
    if (klasseId != null) {
      faecher = faecher.where((f) => 
        f.klassenIds.contains(klasseId)
      ).toList();
    }
    
    // Sort by name
    faecher.sort((a, b) => a.name.compareTo(b.name));

    // Apply pagination
    final totalCount = faecher.length;
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalCount);
    
    final paginatedFaecher = faecher.sublist(
      startIndex.clamp(0, totalCount),
      endIndex,
    );

    return FaecherListResponse(
      faecher: paginatedFaecher.map((f) => FachMapper.toResponse(f)).toList(),
      total: totalCount,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<List<String>> getAlleKuerzel() async {
    await _initializeMockData();
    await _simulateLatency();

    final kuerzel = _database.values
        .map((f) => f.kuerzel)
        .toSet()
        .toList();
    
    kuerzel.sort();
    return kuerzel;
  }

  @override
  Future<bool> istKuerzelVerfuegbar(String kuerzel, {String? excludeFachId}) async {
    await _initializeMockData();
    await _simulateLatency(50); // Faster for validation checks

    return !_database.values.any((f) => 
      (excludeFachId == null || f.id != excludeFachId) &&
      f.kuerzel.toLowerCase() == kuerzel.toLowerCase()
    );
  }

  /// Helper method to clear all data (useful for testing)
  static void clearAllData() {
    _database.clear();
    _isInitialized = false;
  }

  /// Helper method to get current database state (useful for debugging)
  static Map<String, Fach> getCurrentDatabase() {
    return Map.unmodifiable(_database);
  }
}
