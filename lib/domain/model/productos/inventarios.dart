class Inventarios {
  dynamic id;
  dynamic nombre;
  dynamic basedatos;
  dynamic almacen;
  dynamic activo;
  dynamic fecha;

  Inventarios(
      {required this.id,
      required this.nombre,
      required this.basedatos,
      required this.almacen,
      required this.activo,
      required this.fecha});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'basedatos': basedatos,
      'almacen': almacen,
      'activo': activo,
      'fecha': fecha
    };
  }

  factory Inventarios.fromMap(Map<String, dynamic> map) {
    return Inventarios(
        id: map['id'],
        nombre: map['nombre'],
        basedatos: map['basedatos'],
        almacen: map['almacen'],
        activo: map['activo'],
        fecha: map['fecha']);
  }
}
