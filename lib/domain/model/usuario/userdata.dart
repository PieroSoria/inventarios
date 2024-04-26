class UserData {
  String nombre, apellido, email, pass, token, fechacad,ruc,razonSocial;
  UserData(
      {required this.nombre,
      required this.apellido,
      required this.email,
      required this.pass,
      required this.token,
      required this.fechacad,
      required this.ruc,
      required this.razonSocial});
  Map<String, dynamic> tomap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'pass': pass,
      'token': token,
      'fecha': fechacad,
      'ruc':ruc,
      'razonsocial':razonSocial,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      email: map['email'] ?? '',
      pass: map['pass'] ?? '',
      token: map['token'] ?? '',
      fechacad: map['fecha'] ?? '',
      ruc: map['ruc'] ?? '',
      razonSocial: map['razonsocial'] ?? '',
    );
  }
}

class ResponsyUserData {
  UserData? data;
  String? error;
  ResponsyUserData(this.data, this.error);
}
