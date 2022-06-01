class GrapeReception {
  final String date;
  late String? id;
  final String varietal;
  final String ranch;
  final double brix;
  final double ph;
  final double kilos;
  final String responsible;

  GrapeReception(
      {required this.date,
      this.id,
      required this.varietal,
      required this.ranch,
      required this.brix,
      required this.ph,
      required this.kilos,
      required this.responsible});

  GrapeReception.fromMap(Map<String, dynamic> map)
      : date = map['date'],
        varietal = map['varietal'],
        ranch = map['ranch'],
        brix = double.parse(map['brix'].toString()),
        ph = double.parse(map['ph'].toString()),
        kilos = double.parse(map['kilos'].toString()),
        responsible = map['responsible'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'varietal': varietal,
        'ranch': ranch,
        'brix': brix,
        'ph': ph,
        'kilos': kilos,
        'responsible': responsible
      };

  static List<String> titles = [
    'Fecha',
    'Id',
    'Varietal',
    'Rancho',
    'Brix',
    'PH',
    'Kilos',
    'Acciones'
  ];

  @override
  String toString() {
    return 'fecha: $date, varietal: $varietal, rancho: $ranch, brix: $brix, ph: $ph, kilos:$kilos';
  }
}
