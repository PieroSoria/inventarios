class Productos {
  String id,
      codigo,
      codbarra,
      descripcion,
      medida,
      categoria,
      precio,
      stock,
      conteo,
      diferencia;
  Productos(
      {required this.id,
      required this.codigo,
      required this.codbarra,
      required this.descripcion,
      required this.medida,
      required this.categoria,
      required this.precio,
      required this.stock,
      required this.conteo,
      required this.diferencia});
  Map<String, dynamic> toMap2() {
    return {
      'id': id,
      'codigo': codigo,
      'codbarra': codbarra,
      'descripcion': descripcion,
      'medida': medida,
      'categoria': categoria,
      'precio': precio,
      'stock_inicial': stock,
      'conteo': conteo,
      'diferencia': diferencia
    };
  }

  factory Productos.fromMap(Map<String, dynamic> map2) {
    return Productos(
        id: map2['id'] ?? "",
        codigo: map2['codigo'] ?? "",
        codbarra: map2['codbarra'] ?? "",
        descripcion: map2['descripcion'] ?? "",
        medida: map2['medida'] ?? "",
        categoria: map2['categoria'] ?? "",
        precio: map2['precio'] ?? "",
        stock: map2['stock_inicial'] ?? "",
        conteo: map2['conteo'] ?? "",
        diferencia: map2['diferencia'] ?? "");
  }
}
