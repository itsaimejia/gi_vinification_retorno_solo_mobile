class Fermentation {
  final String date;
  late String? id;
  final String activity;
  final int time;
  final String responsible;
  final String observations;
  final String whoMade;

  Fermentation(
      {required this.date,
      this.id,
      required this.activity,
      required this.time,
      required this.responsible,
      required this.observations,
      required this.whoMade});

  Fermentation.fromMap(Map<String, dynamic> map)
      : date = map['date'],
        activity = map['activity'],
        time = map['time'],
        responsible = map['responsible'],
        observations = map['observations'],
        whoMade = map['who_made'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'activity': activity,
        'time': time,
        'responsible': responsible,
        'observations': observations,
        'who_made': whoMade
      };
  static List<String> titles = [
    'Fecha',
    'Id',
    'Actividad',
    'Tiempo',
    'Quién realizó',
    'Observ.',
    'Acciones'
  ];
}
