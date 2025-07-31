import '../models/klasse.dart';
import '../dtos/klasse_dtos.dart';

/// Service-Interface für die Klassen-Verwaltung
/// 
/// Definiert den API-Vertrag für alle Klassen-bezogenen Operationen.
/// Diese Abstraktion ermöglicht es, verschiedene Implementierungen
/// (Mock, HTTP, lokale DB) zu verwenden, ohne die UI zu ändern.
abstract class KlassenService {
  /// Lädt alle Klassen (aktive und archivierte)
  /// 
  /// [includeArchived] - Wenn false, werden nur aktive Klassen zurückgegeben
  /// [page] - Seitenzahl für Pagination (1-basiert)
  /// [pageSize] - Anzahl Einträge pro Seite
  Future<KlassenListResponse> getAlleKlassen({
    bool includeArchived = false,
    int page = 1,
    int pageSize = 20,
  });

  /// Lädt eine einzelne Klasse anhand der ID
  /// 
  /// Wirft [KlasseNotFoundException] wenn die Klasse nicht existiert
  Future<KlasseResponse> getKlasseById(String id);

  /// Erstellt eine neue Klasse
  /// 
  /// [dto] - Die Daten für die neue Klasse
  /// Returns: Die erstellte Klasse mit generierter ID
  /// Wirft [KlasseValidationException] bei Validierungsfehlern
  Future<KlasseResponse> klasseErstellen(KlasseCreateDto dto);

  /// Aktualisiert eine existierende Klasse
  /// 
  /// [id] - Die ID der zu aktualisierenden Klasse
  /// [dto] - Die zu aktualisierenden Felder (nur nicht-null Werte werden geändert)
  /// Returns: Die aktualisierte Klasse
  /// Wirft [KlasseNotFoundException] wenn die Klasse nicht existiert
  /// Wirft [KlasseValidationException] bei Validierungsfehlern
  Future<KlasseResponse> klasseBearbeiten(String id, KlasseUpdateDto dto);

  /// Archiviert eine Klasse (Soft Delete)
  /// 
  /// [id] - Die ID der zu archivierenden Klasse
  /// Wirft [KlasseNotFoundException] wenn die Klasse nicht existiert
  Future<void> klasseArchivieren(String id);

  /// Stellt eine archivierte Klasse wieder her
  /// 
  /// [id] - Die ID der wiederherzustellenden Klasse
  /// Wirft [KlasseNotFoundException] wenn die Klasse nicht existiert
  Future<void> klasseWiederherstellen(String id);

  /// Löscht eine Klasse permanent (Hard Delete)
  /// 
  /// [id] - Die ID der zu löschenden Klasse
  /// [force] - Wenn true, wird auch bei zugeordneten Schülern gelöscht
  /// Wirft [KlasseNotFoundException] wenn die Klasse nicht existiert
  /// Wirft [KlasseHasStudentsException] wenn die Klasse Schüler hat und force=false
  Future<void> klasseLoeschen(String id, {bool force = false});

  /// Sucht Klassen anhand von Kriterien
  /// 
  /// [query] - Suchbegriff (durchsucht Name und Schuljahr)
  /// [schuljahr] - Filter nach Schuljahr
  /// [includeArchived] - Archivierte Klassen einschließen
  Future<KlassenListResponse> sucheKlassen({
    String? query,
    String? schuljahr,
    bool includeArchived = false,
    int page = 1,
    int pageSize = 20,
  });

  /// Gibt alle verfügbaren Schuljahre zurück
  Future<List<String>> getAlleSchuljahre();
}

/// Exception-Klassen für die Klassen-Verwaltung
class KlasseNotFoundException implements Exception {
  final String message;
  final String klasseId;

  const KlasseNotFoundException(this.klasseId) 
      : message = 'Klasse mit ID "$klasseId" nicht gefunden';

  @override
  String toString() => 'KlasseNotFoundException: $message';
}

class KlasseValidationException implements Exception {
  final String message;
  final Map<String, String> fieldErrors;

  const KlasseValidationException(this.message, [this.fieldErrors = const {}]);

  @override
  String toString() => 'KlasseValidationException: $message';
}

class KlasseHasStudentsException implements Exception {
  final String message;
  final String klasseId;
  final int studentCount;

  const KlasseHasStudentsException(this.klasseId, this.studentCount)
      : message = 'Klasse "$klasseId" hat noch $studentCount Schüler und kann nicht gelöscht werden';

  @override
  String toString() => 'KlasseHasStudentsException: $message';
}

/// Mapper-Klasse für die Konvertierung zwischen Domain-Models und DTOs
class KlasseMapper {
  /// Konvertiert ein Domain-Model zu einem Response-DTO
  static KlasseResponse toResponse(Klasse klasse, {int schuelerAnzahl = 0}) {
    return KlasseResponse(
      id: klasse.id,
      name: klasse.name,
      schuljahr: klasse.schuljahr,
      erstelltAm: klasse.erstelltAm,
      istArchiviert: klasse.istArchiviert,
      schuelerAnzahl: schuelerAnzahl,
    );
  }

  /// Konvertiert ein Response-DTO zu einem Domain-Model
  static Klasse fromResponse(KlasseResponse response) {
    return Klasse(
      id: response.id,
      name: response.name,
      schuljahr: response.schuljahr,
      erstelltAm: response.erstelltAm,
      istArchiviert: response.istArchiviert,
    );
  }

  /// Konvertiert ein CreateDto zu einem Domain-Model
  static Klasse fromCreateDto(KlasseCreateDto dto) {
    return Klasse.neu(
      name: dto.name,
      schuljahr: dto.schuljahr,
    );
  }
}
