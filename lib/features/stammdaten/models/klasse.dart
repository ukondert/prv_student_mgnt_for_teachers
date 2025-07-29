import 'package:uuid/uuid.dart';

class Klasse {
  final String id;
  final String name;
  final String schuljahr;
  final DateTime erstelltAm;
  final bool istArchiviert;

  const Klasse({
    required this.id,
    required this.name,
    required this.schuljahr,
    required this.erstelltAm,
    this.istArchiviert = false,
  });

  factory Klasse.neu({
    required String name,
    required String schuljahr,
  }) {
    return Klasse(
      id: const Uuid().v4(),
      name: name,
      schuljahr: schuljahr,
      erstelltAm: DateTime.now(),
    );
  }

  factory Klasse.fromJson(Map<String, dynamic> json) => Klasse(
        id: json['id'] as String,
        name: json['name'] as String,
        schuljahr: json['schuljahr'] as String,
        erstelltAm: DateTime.parse(json['erstelltAm'] as String),
        istArchiviert: json['istArchiviert'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'schuljahr': schuljahr,
        'erstelltAm': erstelltAm.toIso8601String(),
        'istArchiviert': istArchiviert,
      };

  Klasse copyWith({
    String? id,
    String? name,
    String? schuljahr,
    DateTime? erstelltAm,
    bool? istArchiviert,
  }) =>
      Klasse(
        id: id ?? this.id,
        name: name ?? this.name,
        schuljahr: schuljahr ?? this.schuljahr,
        erstelltAm: erstelltAm ?? this.erstelltAm,
        istArchiviert: istArchiviert ?? this.istArchiviert,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Klasse && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Klasse{id: $id, name: $name, schuljahr: $schuljahr}';
}

// DTOs für API-Aufrufe
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
}

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
}
