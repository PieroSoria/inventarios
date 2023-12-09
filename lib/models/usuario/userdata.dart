class UserData {
  String nombre, apellido, email, pass, token;
  UserData(
      {required this.nombre,
      required this.apellido,
      required this.email,
      required this.pass,
      required this.token});
  Map<String, dynamic> tomap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'pass': pass,
      'token': token
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      email: map['email'] ?? '',
      pass: map['pass'] ?? '',
      token: map['token'] ?? '',
    );
  }

  void assignAll() {}
}

class ResponsyUserData{
  UserData? data; 
  String? error;
  ResponsyUserData(this.data,this.error);
}
