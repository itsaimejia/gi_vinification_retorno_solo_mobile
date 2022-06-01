class Tank {
  Tank(
      {this.tankId,
      required this.blem,
      required this.liters,
      required this.wineType,
      required this.brothOrMixture});

  final String blem;
  final double liters;
  final String wineType;
  String? tankId;
  final String brothOrMixture;

  factory Tank.fromMap(Map<String, dynamic> map) => Tank(
      blem: map['blem'],
      liters: map["liters"],
      wineType: map['wine_type'],
      brothOrMixture: map['broth_or_mixture']);

  Map<String, dynamic> toJson() => {
        "blem": blem,
        "liters": liters,
        'wine_type': wineType,
        'broth_or_mixture': brothOrMixture
      };
  @override
  String toString() {
    return '$tankId, $blem, $liters, $wineType, $brothOrMixture';
  }

  static List<String> titles = ['Tanque', 'Tipo', 'Blem', 'Litros'];
}

class BlemTank {
  BlemTank({
    required this.percentage,
    required this.varietal,
  });

  final int percentage;
  final String varietal;

  @override
  String toString() {
    return '$varietal-$percentage';
  }
}
