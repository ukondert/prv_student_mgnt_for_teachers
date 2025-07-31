import '../models/fach.dart';
import '../dtos/fach_dtos.dart';

/// Service-Interface für die Fächer-Verwaltung
/// 
/// Definiert den API-Vertrag für alle Fächer-bezogenen Operationen.
/// Diese Abstraktion ermöglicht es, verschiedene Implementierungen
/// (Mock, HTTP, lokale DB) zu verwenden, ohne die UI zu ändern.
abstract class FaecherService {
  /// Lädt alle Fächer
  /// 
  /// [page] - Seitenzahl für Pagination (1-basiert)
  /// [pageSize] - Anzahl Einträge pro Seite
  /// [includeKlassenInfo] - Wenn true, werden Klassen-Details mitgeladen
  Future<FaecherListResponse> getAlleFaecher({
    int page = 1,
    int pageSize = 20,
    bool includeKlassenInfo = true,
  });

  /// Lädt ein einzelnes Fach anhand der ID
  /// 
  /// [includeKlassenInfo] - Wenn true, werden Klassen-Details mitgeladen
  /// Wirft [FachNotFoundException] wenn das Fach nicht existiert
  Future<FachResponse> getFachById(String id, {bool includeKlassenInfo = true});

  /// Erstellt ein neues Fach
  /// 
  /// [dto] - Die Daten für das neue Fach
  /// Returns: Das erstellte Fach mit generierter ID
  /// Wirft [FachValidationException] bei Validierungsfehlern
  Future<FachResponse> fachErstellen(FachCreateDto dto);

  /// Aktualisiert ein existierendes Fach
  /// 
  /// [id] - Die ID des zu aktualisierenden Fachs
  /// [dto] - Die zu aktualisierenden Felder (nur nicht-null Werte werden geändert)
  /// Returns: Das aktualisierte Fach
  /// Wirft [FachNotFoundException] wenn das Fach nicht existiert
  /// Wirft [FachValidationException] bei Validierungsfehlern
  Future<FachResponse> fachBearbeiten(String id, FachUpdateDto dto);

  /// Löscht ein Fach permanent
  /// 
  /// [id] - Die ID des zu löschenden Fachs
  /// [force] - Wenn true, wird auch bei zugeordneten Bewertungen gelöscht
  /// Wirft [FachNotFoundException] wenn das Fach nicht existiert
  /// Wirft [FachHasGradesException] wenn das Fach Bewertungen hat und force=false
  Future<void> fachLoeschen(String id, {bool force = false});

  /// Ordnet eine Klasse einem Fach zu
  /// 
  /// [fachId] - Die ID des Fachs
  /// [klasseId] - Die ID der Klasse
  /// Wirft [FachNotFoundException] wenn das Fach nicht existiert
  /// Wirft [KlasseNotFoundException] wenn die Klasse nicht existiert
  Future<void> klasseFachZuordnen(String fachId, String klasseId);

  /// Entfernt eine Klasse von einem Fach
  /// 
  /// [fachId] - Die ID des Fachs
  /// [klasseId] - Die ID der Klasse
  /// Wirft [FachNotFoundException] wenn das Fach nicht existiert
  /// Wirft [KlasseNotFoundException] wenn die Klasse nicht existiert
  Future<void> klasseFachEntfernen(String fachId, String klasseId);

  /// Führt Batch-Zuordnungen durch
  /// 
  /// [fachId] - Die ID des Fachs
  /// [klassenIds] - Liste der Klassen-IDs, die dem Fach zugeordnet werden sollen
  /// [replaceExisting] - Wenn true, werden bestehende Zuordnungen ersetzt
  /// Wirft [FachNotFoundException] wenn das Fach nicht existiert
  Future<void> batchKlassenZuordnen(String fachId, List<String> klassenIds, {bool replaceExisting = false});

  /// Sucht Fächer anhand von Kriterien
  /// 
  /// [query] - Suchbegriff (durchsucht Name und Kürzel)
  /// [klasseId] - Filter nach Klassen-ID (nur Fächer dieser Klasse)
  Future<FaecherListResponse> sucheFaecher({
    String? query,
    String? klasseId,
    int page = 1,
    int pageSize = 20,
  });

  /// Gibt alle verfügbaren Fach-Kürzel zurück
  Future<List<String>> getAlleKuerzel();

  /// Prüft, ob ein Kürzel bereits verwendet wird
  /// 
  /// [kuerzel] - Das zu prüfende Kürzel
  /// [excludeFachId] - Fach-ID, die von der Prüfung ausgeschlossen wird (für Updates)
  Future<bool> istKuerzelVerfuegbar(String kuerzel, {String? excludeFachId});
}

/// Exception-Klassen für die Fächer-Verwaltung
class FachNotFoundException implements Exception {
  final String message;
  final String fachId;

  const FachNotFoundException(this.fachId) 
      : message = 'Fach mit ID "$fachId" nicht gefunden';

  @override
  String toString() => 'FachNotFoundException: $message';
}

class FachValidationException implements Exception {
  final String message;
  final Map<String, String> fieldErrors;

  const FachValidationException(this.message, [this.fieldErrors = const {}]);

  @override
  String toString() => 'FachValidationException: $message';
}

class FachHasGradesException implements Exception {
  final String message;
  final String fachId;
  final int gradeCount;

  const FachHasGradesException(this.fachId, this.gradeCount)
      : message = 'Fach "$fachId" hat noch $gradeCount Bewertungen und kann nicht gelöscht werden';

  @override
  String toString() => 'FachHasGradesException: $message';
}

class KlasseNotFoundException implements Exception {
  final String message;
  final String klasseId;

  const KlasseNotFoundException(this.klasseId) 
      : message = 'Klasse mit ID "$klasseId" nicht gefunden';

  @override
  String toString() => 'KlasseNotFoundException: $message';
}

/// Mapper-Klasse für die Konvertierung zwischen Domain-Models und DTOs
class FachMapper {
  /// Konvertiert ein Domain-Model zu einem Response-DTO
  static FachResponse toResponse(Fach fach, {List<KlasseInfo> zugeordneteKlassen = const []}) {
    return FachResponse(
      id: fach.id,
      name: fach.name,
      kuerzel: fach.kuerzel,
      klassenIds: fach.klassenIds,
      erstelltAm: fach.erstelltAm,
      zugeordneteKlassen: zugeordneteKlassen,
    );
  }

  /// Konvertiert ein Response-DTO zu einem Domain-Model
  static Fach fromResponse(FachResponse response) {
    return Fach(
      id: response.id,
      name: response.name,
      kuerzel: response.kuerzel,
      klassenIds: response.klassenIds,
      erstelltAm: response.erstelltAm,
    );
  }

  /// Konvertiert ein CreateDto zu einem Domain-Model
  static Fach fromCreateDto(FachCreateDto dto) {
    return Fach.neu(
      name: dto.name,
      kuerzel: dto.kuerzel,
      klassenIds: dto.klassenIds,
    );
  }
}
