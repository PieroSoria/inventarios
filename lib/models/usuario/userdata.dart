class UserData {
  String nombre, apellido, email, pass;
  UserData(
      {required this.nombre,
      required this.apellido,
      required this.email,
      required this.pass});
  Map<String, dynamic> tomap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'pass': pass,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      email: map['email'] ?? '',
      pass: map['pass'] ?? '',
    );
  }
}
