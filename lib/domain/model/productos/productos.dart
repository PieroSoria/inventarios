class Productos {
  dynamic id,
      codbarra,
      producto,
      almacen,
      medida,
      categoria,
      precio,
      stock,
      conteo,
      diferencia,
      tipoproducto,
      valor,
      fechapro,
      fechacad,
      comentario,
      tdatos;
  Productos(
      {required this.id,
      required this.codbarra,
      required this.producto,
      required this.almacen,
      required this.medida,
      required this.categoria,
      required this.precio,
      required this.stock,
      required this.conteo,
      required this.diferencia,
      required this.tipoproducto,
      required this.valor,
      required this.fechapro,
      required this.fechacad,
      required this.comentario,
      required this.tdatos});
  Map<String, dynamic> toMap2() {
    return {
      'id': id,
      'codbarra': codbarra,
      'producto': producto,
      'almacen': almacen,
      'medida': medida,
      'categoria': categoria,
      'precio': precio,
      'stock_inicial': stock,
      'conteo': conteo,
      'diferencia': diferencia,
      'tipoproducto': tipoproducto,
      'valor': valor,
      'fecha_pro': fechapro,
      'fecha_cad': fechacad,
      'comentario': comentario,
      'tdatos': tdatos
    };
  }

  factory Productos.fromMap(Map<String, dynamic> map2) {
    return Productos(
      id: map2['id'],
      codbarra: map2['codbarra'],
      producto: map2['producto'],
      almacen: map2['almacen'],
      medida: map2['medida'],
      categoria: map2['categoria'],
      precio: map2['precio'],
      stock: map2['stock_inicial'],
      conteo: map2['conteo'],
      diferencia: map2['diferencia'],
      tipoproducto: map2['tipoproducto'],
      valor: map2['valor'],
      fechapro: map2['fecha_pro'],
      fechacad: map2['fecha_cad'],
      comentario: map2['comentario'],
      tdatos: map2['tdatos'],
    );
  }
}
