class DataUser {
  late String? uid;
  final String name;
  final String surnames;
  final String role;
  final String email;

  DataUser(
      {this.uid,
      required this.name,
      required this.surnames,
      required this.role,
      required this.email});

  DataUser.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        surnames = map['surnames'],
        role = map['role'],
        email = map['email'];

  Map<String, dynamic> toJson() =>
      {'name': name, 'surnames': surnames, 'email': email, 'role': role};

  @override
  String toString() {
    return '{uid: $uid, name: $name, surnames: $surnames, email: $email, rol: $role}';
  }
}
