import 'package:uuid/uuid.dart';

class Fach {
  final String id;
  final String name;
  final String kuerzel;
  final List<String> klassenIds;
  final DateTime erstelltAm;

  const Fach({
    required this.id,
    required this.name,
    required this.kuerzel,
    required this.klassenIds,
    required this.erstelltAm,
  });

  factory Fach.neu({
    required String name,
    required String kuerzel,
    List<String> klassenIds = const [],
  }) {
    return Fach(
      id: const Uuid().v4(),
      name: name,
      kuerzel: kuerzel,
      klassenIds: List.from(klassenIds),
      erstelltAm: DateTime.now(),
    );
  }

  factory Fach.fromJson(Map<String, dynamic> json) => Fach(
        id: json['id'] as String,
        name: json['name'] as String,
        kuerzel: json['kuerzel'] as String,
        klassenIds: List<String>.from(json['klassenIds'] as List),
        erstelltAm: DateTime.parse(json['erstelltAm'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kuerzel': kuerzel,
        'klassenIds': klassenIds,
        'erstelltAm': erstelltAm.toIso8601String(),
      };

  Fach copyWith({
    String? id,
    String? name,
    String? kuerzel,
    List<String>? klassenIds,
    DateTime? erstelltAm,
  }) =>
      Fach(
        id: id ?? this.id,
        name: name ?? this.name,
        kuerzel: kuerzel ?? this.kuerzel,
        klassenIds: klassenIds ?? List.from(this.klassenIds),
        erstelltAm: erstelltAm ?? this.erstelltAm,
      );

  Fach addKlasse(String klasseId) {
    if (!klassenIds.contains(klasseId)) {
      return copyWith(klassenIds: [...klassenIds, klasseId]);
    }
    return this;
  }

  Fach removeKlasse(String klasseId) {
    return copyWith(
      klassenIds: klassenIds.where((id) => id != klasseId).toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fach && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Fach{id: $id, name: $name, kuerzel: $kuerzel, klassenIds: $klassenIds}';
}

// DTOs für API-Aufrufe
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
}

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
}
