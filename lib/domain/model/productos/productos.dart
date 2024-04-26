class Productos {
  dynamic id,
      codbarra,
      producto,
      almacen,
      subalmacen,
      medida,
      categoria,
      precio,
      stock,
      conteo,
      diferencia,
      lote,
      numlote,
      fechapro,
      fechacad,
      serie,
      numserie,
      tdatos;
  Productos(
      {required this.id,
      required this.codbarra,
      required this.producto,
      required this.almacen,
      required this.subalmacen,
      required this.medida,
      required this.categoria,
      required this.precio,
      required this.stock,
      required this.conteo,
      required this.diferencia,
      required this.lote,
      required this.numlote,
      required this.fechapro,
      required this.fechacad,
      required this.serie,
      required this.numserie,
      required this.tdatos});
  Map<String, dynamic> toMap2() {
    return {
      'id': id,
      'codbarra': codbarra,
      'producto': producto,
      'almacen': almacen,
      'subalmacen': subalmacen,
      'medida': medida,
      'categoria': categoria,
      'precio': precio,
      'stock_inicial': stock,
      'conteo': conteo,
      'diferencia': diferencia,
      'lote': lote,
      'num_lote': numlote,
      'fecha_pro': fechapro,
      'fecha_cad': fechacad,
      'serie': serie,
      'num_serie': numserie,
      'tdatos': tdatos
    };
  }

  factory Productos.fromMap(Map<String, dynamic> map2) {
    return Productos(
      id: map2['id'],
      codbarra: map2['codbarra'],
      producto: map2['producto'],
      almacen: map2['almacen'],
      subalmacen: map2['subalmacen'],
      medida: map2['medida'],
      categoria: map2['categoria'],
      precio: map2['precio'],
      stock: map2['stock_inicial'],
      conteo: map2['conteo'],
      diferencia: map2['diferencia'],
      lote: map2['lote'],
      numlote: map2['num_lote'],
      fechapro: map2['fecha_pro'],
      fechacad: map2['fecha_cad'],
      serie: map2['serie'],
      numserie: map2['num_serie'],
      tdatos: map2['tdatos'],
    );
  }
}
