abstract class ExcelRepositoryInterface {
  Future<List<List<dynamic>>> insertarDatosDesdeExcel(
      {required String filePath, required String basedatos});
  Future<List<List<dynamic>>> leerExcel({required String filePath});
  Future<bool> convertTableToExcel(
      {required String name, required List<Map<String, dynamic>> tabledata});
}
