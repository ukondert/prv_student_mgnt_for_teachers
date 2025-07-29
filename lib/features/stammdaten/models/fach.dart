import 'package:uuid/uuid.dart';

class Fach {
  final String id;
  final String name;
  final List<String> klassenIds;
  final DateTime erstelltAm;

  const Fach({
    required this.id,
    required this.name,
    required this.klassenIds,
    required this.erstelltAm,
  });

  factory Fach.neu({
    required String name,
    List<String> klassenIds = const [],
  }) {
    return Fach(
      id: const Uuid().v4(),
      name: name,
      klassenIds: List.from(klassenIds),
      erstelltAm: DateTime.now(),
    );
  }

  factory Fach.fromJson(Map<String, dynamic> json) => Fach(
        id: json['id'] as String,
        name: json['name'] as String,
        klassenIds: List<String>.from(json['klassenIds'] as List),
        erstelltAm: DateTime.parse(json['erstelltAm'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'klassenIds': klassenIds,
        'erstelltAm': erstelltAm.toIso8601String(),
      };

  Fach copyWith({
    String? id,
    String? name,
    List<String>? klassenIds,
    DateTime? erstelltAm,
  }) =>
      Fach(
        id: id ?? this.id,
        name: name ?? this.name,
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
  String toString() => 'Fach{id: $id, name: $name, klassenIds: $klassenIds}';
}

// DTOs für API-Aufrufe
class FachCreateDto {
  final String name;
  final List<String> klassenIds;

  const FachCreateDto({
    required this.name,
    this.klassenIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'klassenIds': klassenIds,
      };
}

class FachUpdateDto {
  final String? name;
  final List<String>? klassenIds;

  const FachUpdateDto({
    this.name,
    this.klassenIds,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (name != null) json['name'] = name;
    if (klassenIds != null) json['klassenIds'] = klassenIds;
    return json;
  }
}
