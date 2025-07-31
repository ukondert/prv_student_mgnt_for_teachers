/// Data Transfer Objects für die Klassen-Verwaltung
/// 
/// Diese DTOs definieren die API-Verträge für die Kommunikation zwischen
/// Frontend und Backend. Sie sind von den Domain-Models getrennt, um
/// eine saubere Architektur zu gewährleisten.

/// DTO für das Erstellen einer neuen Klasse
class KlasseCreateDto {
  final String name;
  final String schuljahr;

  const KlasseCreateDto({
    required this.name,
    required this.schuljahr,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'schuljahr': schuljahr,
      };

  factory KlasseCreateDto.fromJson(Map<String, dynamic> json) => KlasseCreateDto(
        name: json['name'] as String,
        schuljahr: json['schuljahr'] as String,
      );

  @override
  String toString() => 'KlasseCreateDto(name: $name, schuljahr: $schuljahr)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlasseCreateDto && 
      runtimeType == other.runtimeType &&
      name == other.name &&
      schuljahr == other.schuljahr;

  @override
  int get hashCode => name.hashCode ^ schuljahr.hashCode;
}

/// DTO für das Aktualisieren einer existierenden Klasse
class KlasseUpdateDto {
  final String? name;
  final String? schuljahr;
  final bool? istArchiviert;

  const KlasseUpdateDto({
    this.name,
    this.schuljahr,
    this.istArchiviert,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (name != null) json['name'] = name;
    if (schuljahr != null) json['schuljahr'] = schuljahr;
    if (istArchiviert != null) json['istArchiviert'] = istArchiviert;
    return json;
  }

  factory KlasseUpdateDto.fromJson(Map<String, dynamic> json) => KlasseUpdateDto(
        name: json['name'] as String?,
        schuljahr: json['schuljahr'] as String?,
        istArchiviert: json['istArchiviert'] as bool?,
      );

  /// Erstellt ein DTO nur für das Archivieren einer Klasse
  factory KlasseUpdateDto.archive() => const KlasseUpdateDto(istArchiviert: true);

  /// Erstellt ein DTO nur für das Wiederherstellen einer Klasse
  factory KlasseUpdateDto.restore() => const KlasseUpdateDto(istArchiviert: false);

  @override
  String toString() => 'KlasseUpdateDto(name: $name, schuljahr: $schuljahr, istArchiviert: $istArchiviert)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlasseUpdateDto && 
      runtimeType == other.runtimeType &&
      name == other.name &&
      schuljahr == other.schuljahr &&
      istArchiviert == other.istArchiviert;

  @override
  int get hashCode => name.hashCode ^ schuljahr.hashCode ^ istArchiviert.hashCode;
}

/// Response DTO für Klassen-Listen mit Metadaten
class KlassenListResponse {
  final List<KlasseResponse> klassen;
  final int total;
  final int page;
  final int pageSize;

  const KlassenListResponse({
    required this.klassen,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });

  factory KlassenListResponse.fromJson(Map<String, dynamic> json) => KlassenListResponse(
        klassen: (json['klassen'] as List)
            .map((e) => KlasseResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        page: json['page'] as int? ?? 1,
        pageSize: json['pageSize'] as int? ?? 20,
      );

  Map<String, dynamic> toJson() => {
        'klassen': klassen.map((e) => e.toJson()).toList(),
        'total': total,
        'page': page,
        'pageSize': pageSize,
      };
}

/// Response DTO für eine einzelne Klasse
class KlasseResponse {
  final String id;
  final String name;
  final String schuljahr;
  final DateTime erstelltAm;
  final bool istArchiviert;
  final int schuelerAnzahl;

  const KlasseResponse({
    required this.id,
    required this.name,
    required this.schuljahr,
    required this.erstelltAm,
    this.istArchiviert = false,
    this.schuelerAnzahl = 0,
  });

  factory KlasseResponse.fromJson(Map<String, dynamic> json) => KlasseResponse(
        id: json['id'] as String,
        name: json['name'] as String,
        schuljahr: json['schuljahr'] as String,
        erstelltAm: DateTime.parse(json['erstelltAm'] as String),
        istArchiviert: json['istArchiviert'] as bool? ?? false,
        schuelerAnzahl: json['schuelerAnzahl'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'schuljahr': schuljahr,
        'erstelltAm': erstelltAm.toIso8601String(),
        'istArchiviert': istArchiviert,
        'schuelerAnzahl': schuelerAnzahl,
      };

  @override
  String toString() => 'KlasseResponse(id: $id, name: $name, schuljahr: $schuljahr)';
}
