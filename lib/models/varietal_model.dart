class Varietal {
  late String? varietalId;
  late double kilosReceived;
  late double kilosUsed;

  Varietal(
      {this.varietalId, required this.kilosReceived, required this.kilosUsed});

  Varietal.fromMap(Map<String, dynamic> map)
      : kilosReceived = double.parse(map['kilos_received'].toString()),
        kilosUsed = double.parse(map['kilos_used'].toString());

  Map<String, dynamic> toJson() =>
      {'kilos_received': kilosReceived, 'kilos_used': kilosUsed};
  static List<String> titles = ['Varietal', 'Kilos recibidos', 'Kilos usados'];

  @override
  String toString() {
    return 'varietal: $varietalId, kilos recibidos: $kilosReceived, kilos usados: $kilosUsed';
  }
}
