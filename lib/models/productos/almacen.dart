class Almacenes {
  double id;
  String nombre;

  Almacenes({required this.id, required this.nombre});
  Map<String, dynamic> tomap() {
    return {'id': id, 'nombre': nombre};
  }

  factory Almacenes.fromMap(Map<String, dynamic> map) {
    return Almacenes(id: map['id'] ?? 0.0, nombre: map['nombre'] ?? '');
  }
}
