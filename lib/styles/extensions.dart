extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toCapitalizedEachOne() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
  String toEncodeId() =>
      replaceAll(RegExp(' +'), ' ').replaceAll(' ', '_').toLowerCase();
  String toDecodeId() => replaceAll('_', ' ').toCapitalizedEachOne();
  bool get isAName => RegExp(r'^[\w\D ]+$').hasMatch(this);
  bool get isANumber => RegExp(r'^\d+\.?(\d+)?$').hasMatch(this);
  bool get isAIntNumber => RegExp(r'^\d+$').hasMatch(this);
  bool get isAWord => RegExp(r'^[a-zA-Z ]+$').hasMatch(this);
  bool get isAUserName => RegExp(r'^[\w\d]{4,8}$').hasMatch(this);
  bool get isAPassword =>
      RegExp(r'^(?=\w*\d)(?=\w*[A-Z])(?=\w*[a-z])\S{8,}$').hasMatch(this);
  bool get isEmail => RegExp(
          r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$")
      .hasMatch(this);
  bool get isNotAForbiddenUserName =>
      RegExp(r'^(admin|user|demo)$').hasMatch(this);
  bool get isAnID => RegExp(r'^[A-Z]([0-9]{4})$').hasMatch(this);
}
