import '../klassen_service.dart';
import '../../models/klasse.dart';
import '../../dtos/klasse_dtos.dart';

/// MockUp-Server-Implementierung für KlassenService
/// 
/// Diese Implementierung simuliert einen Backend-Server mit In-Memory-Daten.
/// Sie kann später durch eine SQLite- oder HTTP-API-Implementierung ersetzt werden.
/// 
/// Features:
/// - Realistische Latenz-Simulation
/// - Validierung und Error-Handling
/// - Vollständige CRUD-Operationen
/// - Pagination-Support
/// - Robuste Duplikat-Erkennung
class MockKlassenService implements KlassenService {
  // In-Memory Database simulation
  static final Map<String, Klasse> _database = {};
  static bool _isInitialized = false;

  /// Initialize mock data if not already done
  static Future<void> _initializeMockData() async {
    if (_isInitialized) return;

    // Realistic mock data with proper UUIDs
    final mockKlassen = [
      Klasse(
        id: 'f47ac10b-58cc-4372-a567-0e02b2c3d479',
        name: '4AHITS',
        schuljahr: '2024/25',
        erstelltAm: DateTime.now().subtract(const Duration(days: 30)),
        istArchiviert: false,
      ),
      Klasse(
        id: '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        name: '3BHITS',
        schuljahr: '2024/25',
        erstelltAm: DateTime.now().subtract(const Duration(days: 25)),
        istArchiviert: false,
      ),
      Klasse(
        id: '6ba7b811-9dad-11d1-80b4-00c04fd430c8',
        name: '5AHET',
        schuljahr: '2024/25',
        erstelltAm: DateTime.now().subtract(const Duration(days: 20)),
        istArchiviert: false,
      ),
      Klasse(
        id: '6ba7b812-9dad-11d1-80b4-00c04fd430c8',
        name: '2AMIT',
        schuljahr: '2024/25',
        erstelltAm: DateTime.now().subtract(const Duration(days: 15)),
        istArchiviert: false,
      ),
      Klasse(
        id: '6ba7b813-9dad-11d1-80b4-00c04fd430c8',
        name: '1AHITS',
        schuljahr: '2024/25',
        erstelltAm: DateTime.now().subtract(const Duration(days: 10)),
        istArchiviert: false,
      ),
      // Archived example
      Klasse(
        id: 'archived-example-uuid-1234',
        name: '5BHITS',
        schuljahr: '2023/24',
        erstelltAm: DateTime.now().subtract(const Duration(days: 365)),
        istArchiviert: true,
      ),
    ];

    for (final klasse in mockKlassen) {
      _database[klasse.id] = klasse;
    }

    _isInitialized = true;
  }

  /// Simulate realistic network latency
  Future<void> _simulateLatency([int? customMs]) async {
    final latency = customMs ?? (150 + (DateTime.now().millisecond % 350)); // 150-500ms
    await Future.delayed(Duration(milliseconds: latency));
  }

  @override
  Future<KlassenListResponse> getAlleKlassen({
    bool includeArchived = false,
    int page = 1,
    int pageSize = 20,
  }) async {
    await _initializeMockData();
    await _simulateLatency();

    // Validate parameters
    if (page < 1) throw ArgumentError('Page must be >= 1');
    if (pageSize < 1 || pageSize > 100) throw ArgumentError('PageSize must be between 1 and 100');

    // Filter and sort
    var klassen = _database.values.toList();
    
    if (!includeArchived) {
      klassen = klassen.where((k) => !k.istArchiviert).toList();
    }
    
    // Sort by name, then by schuljahr
    klassen.sort((a, b) {
      final nameCompare = a.name.compareTo(b.name);
      if (nameCompare != 0) return nameCompare;
      return a.schuljahr.compareTo(b.schuljahr);
    });

    // Apply pagination
    final totalCount = klassen.length;
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalCount);
    
    final paginatedKlassen = klassen.sublist(
      startIndex.clamp(0, totalCount),
      endIndex,
    );

    return KlassenListResponse(
      klassen: paginatedKlassen.map((k) => KlasseMapper.toResponse(k)).toList(),
      total: totalCount,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<KlasseResponse> getKlasseById(String id) async {
    await _initializeMockData();
    await _simulateLatency();

    final klasse = _database[id];
    if (klasse == null) {
      throw KlasseNotFoundException('Klasse mit ID $id nicht gefunden');
    }

    return KlasseMapper.toResponse(klasse);
  }

  @override
  Future<KlasseResponse> klasseErstellen(KlasseCreateDto dto) async {
    await _initializeMockData();
    await _simulateLatency();

    // Validation
    if (dto.name.trim().isEmpty) {
      throw KlasseValidationException('Klassenname darf nicht leer sein');
    }
    
    if (dto.schuljahr.trim().isEmpty) {
      throw KlasseValidationException('Schuljahr darf nicht leer sein');
    }

    // Check for duplicates
    final duplicate = _database.values.any((k) => 
      k.name.toLowerCase() == dto.name.toLowerCase() && 
      k.schuljahr == dto.schuljahr &&
      !k.istArchiviert
    );
    
    if (duplicate) {
      throw KlasseValidationException(
        'Eine Klasse mit dem Namen "${dto.name}" existiert bereits im Schuljahr ${dto.schuljahr}'
      );
    }

    // Create new Klasse
    final klasse = Klasse.neu(
      name: dto.name.trim(),
      schuljahr: dto.schuljahr.trim(),
    );

    _database[klasse.id] = klasse;

    return KlasseMapper.toResponse(klasse);
  }

  @override
  Future<KlasseResponse> klasseBearbeiten(String id, KlasseUpdateDto dto) async {
    await _initializeMockData();
    await _simulateLatency();

    final existingKlasse = _database[id];
    if (existingKlasse == null) {
      throw KlasseNotFoundException('Klasse mit ID $id nicht gefunden');
    }

    // Validation
    if (dto.name != null && dto.name!.trim().isEmpty) {
      throw KlasseValidationException('Klassenname darf nicht leer sein');
    }
    
    if (dto.schuljahr != null && dto.schuljahr!.trim().isEmpty) {
      throw KlasseValidationException('Schuljahr darf nicht leer sein');
    }

    // Check for duplicates (excluding current record)
    if (dto.name != null || dto.schuljahr != null) {
      final newName = dto.name?.trim() ?? existingKlasse.name;
      final newSchuljahr = dto.schuljahr?.trim() ?? existingKlasse.schuljahr;
      
      final duplicate = _database.values.any((k) => 
        k.id != id &&
        k.name.toLowerCase() == newName.toLowerCase() && 
        k.schuljahr == newSchuljahr &&
        !k.istArchiviert
      );
      
      if (duplicate) {
        throw KlasseValidationException(
          'Eine Klasse mit dem Namen "$newName" existiert bereits im Schuljahr $newSchuljahr'
        );
      }
    }

    // Update Klasse
    final updatedKlasse = existingKlasse.copyWith(
      name: dto.name?.trim(),
      schuljahr: dto.schuljahr?.trim(),
      istArchiviert: dto.istArchiviert,
    );

    _database[id] = updatedKlasse;

    return KlasseMapper.toResponse(updatedKlasse);
  }

  @override
  Future<void> klasseArchivieren(String id) async {
    await _initializeMockData();
    await _simulateLatency();

    final klasse = _database[id];
    if (klasse == null) {
      throw KlasseNotFoundException('Klasse mit ID $id nicht gefunden');
    }

    if (klasse.istArchiviert) {
      throw KlasseValidationException('Klasse ist bereits archiviert');
    }

    _database[id] = klasse.copyWith(istArchiviert: true);
  }

  @override
  Future<void> klasseLoeschen(String id, {bool force = false}) async {
    await _initializeMockData();
    await _simulateLatency();

    if (!_database.containsKey(id)) {
      throw KlasseNotFoundException('Klasse mit ID $id nicht gefunden');
    }

    // In a real implementation, check for students here
    // For now, we just delete directly
    _database.remove(id);
  }

  @override
  Future<void> klasseWiederherstellen(String id) async {
    await _initializeMockData();
    await _simulateLatency();

    final klasse = _database[id];
    if (klasse == null) {
      throw KlasseNotFoundException('Klasse mit ID $id nicht gefunden');
    }

    if (!klasse.istArchiviert) {
      throw KlasseValidationException('Klasse ist nicht archiviert');
    }

    _database[id] = klasse.copyWith(istArchiviert: false);
  }

  @override
  Future<KlassenListResponse> sucheKlassen({
    String? query,
    String? schuljahr,
    bool includeArchived = false,
    int page = 1,
    int pageSize = 20,
  }) async {
    await _initializeMockData();
    await _simulateLatency();

    // Start with all classes
    var klassen = _database.values.toList();
    
    // Apply filters
    if (!includeArchived) {
      klassen = klassen.where((k) => !k.istArchiviert).toList();
    }
    
    if (schuljahr != null) {
      klassen = klassen.where((k) => k.schuljahr == schuljahr).toList();
    }
    
    if (query != null && query.trim().isNotEmpty) {
      final searchTerm = query.toLowerCase();
      klassen = klassen.where((k) => 
        k.name.toLowerCase().contains(searchTerm) ||
        k.schuljahr.toLowerCase().contains(searchTerm)
      ).toList();
    }
    
    // Sort by name
    klassen.sort((a, b) => a.name.compareTo(b.name));

    // Apply pagination
    final totalCount = klassen.length;
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalCount);
    
    final paginatedKlassen = klassen.sublist(
      startIndex.clamp(0, totalCount),
      endIndex,
    );

    return KlassenListResponse(
      klassen: paginatedKlassen.map((k) => KlasseMapper.toResponse(k)).toList(),
      total: totalCount,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<List<String>> getAlleSchuljahre() async {
    await _initializeMockData();
    await _simulateLatency();

    final schuljahre = _database.values
        .map((k) => k.schuljahr)
        .toSet()
        .toList();
    
    schuljahre.sort((a, b) => b.compareTo(a)); // Newest first
    return schuljahre;
  }

  /// Helper method to check if a class exists (for validation)
  Future<bool> klasseExistiert(String name, String schuljahr, {String? excludeId}) async {
    await _initializeMockData();
    await _simulateLatency(50); // Faster for validation checks

    return _database.values.any((k) => 
      (excludeId == null || k.id != excludeId) &&
      k.name.toLowerCase() == name.toLowerCase() && 
      k.schuljahr == schuljahr &&
      !k.istArchiviert
    );
  }

  /// Helper method to clear all data (useful for testing)
  static void clearAllData() {
    _database.clear();
    _isInitialized = false;
  }

  /// Helper method to get current database state (useful for debugging)
  static Map<String, Klasse> getCurrentDatabase() {
    return Map.unmodifiable(_database);
  }
}
