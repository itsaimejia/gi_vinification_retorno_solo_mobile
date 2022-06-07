class Wine {
  late String? id;
  final String date;
  final String type;
  final double liters;
  final String anada;
  final String tankName;
  final String ranch;
  final String observations;
  late String blem;
  final String responsible;

  Wine(
      {this.id,
      required this.blem,
      required this.date,
      required this.type,
      required this.anada,
      required this.tankName,
      required this.liters,
      required this.ranch,
      required this.observations,
      required this.responsible});

  Wine.fromMap(Map<String, dynamic> map)
      : date = map['date'],
        type = map['type'],
        blem = map['blem'],
        liters = double.parse(map["liters"].toString()),
        anada = map['anada'],
        tankName = map['tank_name'],
        ranch = map['ranch'],
        observations = map['observations'],
        responsible = map['responsible'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'type': type,
        'blem': blem,
        'liters': liters,
        'tank_name': tankName,
        'ranch': ranch,
        'anada': anada,
        'observations': observations,
        'responsible': responsible
      };

  static List<String> titles = [
    'Fecha',
    'Id',
    'Tipo',
    'Rancho',
    'Añada',
    'Tanque',
    'Blem',
    'Litros',
    'Observ.',
    'Acciones'
  ];

  static List<String> types = ['Tinto', 'Blanco', 'Rosado', 'Espumoso'];

  @override
  String toString() {
    return 'id:$id, tipo:$type, rancho:$ranch, añada:$anada, tanque:$tankName, blem:$blem';
  }
}

class BlemWine {
  final int percentage;
  final String varietal;
  final String? tankUsed;
  final double quantityUsed;

  BlemWine({
    required this.quantityUsed,
    this.tankUsed,
    required this.percentage,
    required this.varietal,
  });

  @override
  String toString() {
    return tankUsed == null
        ? '$varietal-$percentage-$quantityUsed'
        : '$varietal-$percentage-$tankUsed-$quantityUsed';
  }
}
