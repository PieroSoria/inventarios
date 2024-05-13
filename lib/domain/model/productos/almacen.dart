class Almacenes {
  dynamic id;
  dynamic almacen;

  Almacenes({
    required this.id,
    required this.almacen,
  });
  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'almacen': almacen,
    };
  }

  factory Almacenes.fromMap(Map<String, dynamic> map) {
    return Almacenes(
      id: map['id'],
      almacen: map['almacen'],
    );
  }
}
