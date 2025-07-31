/// Data Transfer Objects für die Fächer-Verwaltung
/// 
/// Diese DTOs definieren die API-Verträge für die Kommunikation zwischen
/// Frontend und Backend. Sie sind von den Domain-Models getrennt, um
/// eine saubere Architektur zu gewährleisten.

/// DTO für das Erstellen eines neuen Fachs
class FachCreateDto {
  final String name;
  final String kuerzel;
  final List<String> klassenIds;

  const FachCreateDto({
    required this.name,
    required this.kuerzel,
    this.klassenIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'kuerzel': kuerzel,
        'klassenIds': klassenIds,
      };

  factory FachCreateDto.fromJson(Map<String, dynamic> json) => FachCreateDto(
        name: json['name'] as String,
        kuerzel: json['kuerzel'] as String,
        klassenIds: List<String>.from(json['klassenIds'] as List? ?? []),
      );

  @override
  String toString() => 'FachCreateDto(name: $name, kuerzel: $kuerzel, klassenIds: $klassenIds)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FachCreateDto && 
      runtimeType == other.runtimeType &&
      name == other.name &&
      kuerzel == other.kuerzel &&
      _listEquals(klassenIds, other.klassenIds);

  @override
  int get hashCode => name.hashCode ^ kuerzel.hashCode ^ klassenIds.hashCode;
}

/// DTO für das Aktualisieren eines existierenden Fachs
class FachUpdateDto {
  final String? name;
  final String? kuerzel;
  final List<String>? klassenIds;

  const FachUpdateDto({
    this.name,
    this.kuerzel,
    this.klassenIds,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (name != null) json['name'] = name;
    if (kuerzel != null) json['kuerzel'] = kuerzel;
    if (klassenIds != null) json['klassenIds'] = klassenIds;
    return json;
  }

  factory FachUpdateDto.fromJson(Map<String, dynamic> json) => FachUpdateDto(
        name: json['name'] as String?,
        kuerzel: json['kuerzel'] as String?,
        klassenIds: json['klassenIds'] != null 
            ? List<String>.from(json['klassenIds'] as List)
            : null,
      );

  @override
  String toString() => 'FachUpdateDto(name: $name, kuerzel: $kuerzel, klassenIds: $klassenIds)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FachUpdateDto && 
      runtimeType == other.runtimeType &&
      name == other.name &&
      kuerzel == other.kuerzel &&
      (klassenIds == null && other.klassenIds == null ||
       klassenIds != null && other.klassenIds != null && _listEquals(klassenIds!, other.klassenIds!));

  @override
  int get hashCode => name.hashCode ^ kuerzel.hashCode ^ klassenIds.hashCode;
}

/// Response DTO für Fächer-Listen mit Metadaten
class FaecherListResponse {
  final List<FachResponse> faecher;
  final int total;
  final int page;
  final int pageSize;

  const FaecherListResponse({
    required this.faecher,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });

  factory FaecherListResponse.fromJson(Map<String, dynamic> json) => FaecherListResponse(
        faecher: (json['faecher'] as List)
            .map((e) => FachResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        page: json['page'] as int? ?? 1,
        pageSize: json['pageSize'] as int? ?? 20,
      );

  Map<String, dynamic> toJson() => {
        'faecher': faecher.map((e) => e.toJson()).toList(),
        'total': total,
        'page': page,
        'pageSize': pageSize,
      };
}

/// Response DTO für ein einzelnes Fach
class FachResponse {
  final String id;
  final String name;
  final String kuerzel;
  final List<String> klassenIds;
  final DateTime erstelltAm;
  final List<KlasseInfo> zugeordneteKlassen;

  const FachResponse({
    required this.id,
    required this.name,
    required this.kuerzel,
    required this.klassenIds,
    required this.erstelltAm,
    this.zugeordneteKlassen = const [],
  });

  factory FachResponse.fromJson(Map<String, dynamic> json) => FachResponse(
        id: json['id'] as String,
        name: json['name'] as String,
        kuerzel: json['kuerzel'] as String,
        klassenIds: List<String>.from(json['klassenIds'] as List? ?? []),
        erstelltAm: DateTime.parse(json['erstelltAm'] as String),
        zugeordneteKlassen: (json['zugeordneteKlassen'] as List? ?? [])
            .map((e) => KlasseInfo.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kuerzel': kuerzel,
        'klassenIds': klassenIds,
        'erstelltAm': erstelltAm.toIso8601String(),
        'zugeordneteKlassen': zugeordneteKlassen.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => 'FachResponse(id: $id, name: $name, kuerzel: $kuerzel)';
}

/// DTO für Klassen-Zuordnungs-Operationen
class FachKlasseZuordnungDto {
  final String fachId;
  final String klasseId;
  final bool zuordnen; // true = zuordnen, false = entfernen

  const FachKlasseZuordnungDto({
    required this.fachId,
    required this.klasseId,
    required this.zuordnen,
  });

  Map<String, dynamic> toJson() => {
        'fachId': fachId,
        'klasseId': klasseId,
        'zuordnen': zuordnen,
      };

  factory FachKlasseZuordnungDto.fromJson(Map<String, dynamic> json) => FachKlasseZuordnungDto(
        fachId: json['fachId'] as String,
        klasseId: json['klasseId'] as String,
        zuordnen: json['zuordnen'] as bool,
      );

  /// Factory für das Zuordnen einer Klasse zu einem Fach
  factory FachKlasseZuordnungDto.zuordnen({
    required String fachId,
    required String klasseId,
  }) => FachKlasseZuordnungDto(
        fachId: fachId,
        klasseId: klasseId,
        zuordnen: true,
      );

  /// Factory für das Entfernen einer Klasse von einem Fach
  factory FachKlasseZuordnungDto.entfernen({
    required String fachId,
    required String klasseId,
  }) => FachKlasseZuordnungDto(
        fachId: fachId,
        klasseId: klasseId,
        zuordnen: false,
      );

  @override
  String toString() => 'FachKlasseZuordnungDto(fachId: $fachId, klasseId: $klasseId, zuordnen: $zuordnen)';
}

/// Minimal-Info über eine Klasse für Zuordnungsanzeigen
class KlasseInfo {
  final String id;
  final String name;
  final String schuljahr;

  const KlasseInfo({
    required this.id,
    required this.name,
    required this.schuljahr,
  });

  factory KlasseInfo.fromJson(Map<String, dynamic> json) => KlasseInfo(
        id: json['id'] as String,
        name: json['name'] as String,
        schuljahr: json['schuljahr'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'schuljahr': schuljahr,
      };

  @override
  String toString() => 'KlasseInfo(id: $id, name: $name, schuljahr: $schuljahr)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlasseInfo && 
      runtimeType == other.runtimeType &&
      id == other.id &&
      name == other.name &&
      schuljahr == other.schuljahr;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ schuljahr.hashCode;
}

/// Helper-Funktion für Listen-Vergleiche
bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
