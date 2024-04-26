class Almacenes {
  dynamic id;
  dynamic almacen;
  dynamic subalmacen;

  Almacenes({
    required this.id,
    required this.almacen,
    required this.subalmacen,
  });
  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'almacen': almacen,
      'subalmacen': subalmacen,
    };
  }

  factory Almacenes.fromMap(Map<String, dynamic> map) {
    return Almacenes(
      id: map['id'],
      almacen: map['almacen'],
      subalmacen: map['subalmacen'],
    );
  }
}
