class Ubicacioneslet {
  double id;
  String ubicacion, sububicaciones;

  Ubicacioneslet(
      {required this.id,
      required this.ubicacion,
      required this.sububicaciones});
  Map<String, dynamic> toMap3() {
    return {'id': id, 'ubicacion': ubicacion, 'sububicacion': sububicaciones};
  }

  factory Ubicacioneslet.fromMap(Map<String, dynamic> map3) {
    return Ubicacioneslet(
        id: map3['id'] ?? 0.0,
        ubicacion: map3['ubicacion'] ?? '',
        sububicaciones: map3['sububicacion'] ?? '');
  }
}
