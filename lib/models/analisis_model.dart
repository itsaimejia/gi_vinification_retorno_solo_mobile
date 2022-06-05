class Analisis {
  final String date;
  late String? id;
  final String type;
  final double brix;
  final double ph;
  final String analysisPerformed;
  final String observations;
  final String itemAnalyzed;
  final String receptionOrTank;
  final String responsible;

  Analisis(
      {required this.date,
      this.id,
      required this.type,
      required this.brix,
      required this.ph,
      required this.analysisPerformed,
      required this.observations,
      required this.itemAnalyzed,
      required this.receptionOrTank,
      required this.responsible});

  Analisis.fromMap(Map<String, dynamic> map)
      : date = map['date'],
        type = map['type'],
        brix = double.parse(map['brix'].toString()),
        ph = double.parse(map['ph'].toString()),
        analysisPerformed = map['analysis_performed'],
        observations = map['observations'],
        itemAnalyzed = map['item_analyzed'],
        receptionOrTank = map['reception_or_tank'],
        responsible = map['responsible'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'type': type,
        'brix': brix,
        'ph': ph,
        'analysis_performed': analysisPerformed,
        'observations': observations,
        'item_analyzed': itemAnalyzed,
        'reception_or_tank': receptionOrTank,
        'responsible': responsible
      };
  static List<String> titles = [
    'Fecha',
    'Id',
    'Tipo',
    'Brix',
    'PH',
    'Análisis',
    'Item',
    'Observ.',
    'Acciones'
  ];
}
