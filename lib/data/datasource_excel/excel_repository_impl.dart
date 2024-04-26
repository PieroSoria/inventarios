import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inventariosnew/domain/repository/excel_repository_interface.dart';
import 'package:path_provider/path_provider.dart';

class ExcelRepositoryImpl implements ExcelRepositoryInterface {
  @override
  Future<List<List<dynamic>>> insertarDatosDesdeExcel(
      {required String filePath, required String basedatos}) async {
    List<List<dynamic>> excelData = await leerExcel(filePath: filePath);
    // await insertarDatos(excelData, basedatos);
    return excelData;
  }

  @override
  Future<List<List<dynamic>>> leerExcel({required String filePath}) async {
    try {
      var bytes = File(filePath).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables[excel.tables.keys.first];
      var rows = sheet!.rows;
      debugPrint(rows.toString());
      return rows.sublist(1);
    } catch (e, stackTrace) {
      debugPrint("Error al leer el archivo Excel: $e");
      debugPrint("StackTrace: $stackTrace");

      return List<List<dynamic>>.empty();
    }
  }

  @override
  Future<bool> convertTableToExcel({
    required String name,
    required List<Map<String, dynamic>> tabledata,
  }) async {
    final excel = Excel.createExcel();

    final sheet = excel['Sheet1'];

    final headers = tabledata.first.keys.toList();
    for (var i = 0; i < headers.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = TextCellValue(headers[i].toString());
    }
    for (var i = 0; i < tabledata.length; i++) {
      final row = tabledata[i];
      final values = row.values.toList();
      for (var j = 0; j < values.length; j++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
            .value = TextCellValue(values[j].toString());
      }
    }

    final outputPath = await FilePicker.platform.getDirectoryPath();

    if (outputPath != null) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final documentsPath = documentsDirectory.path;
      final outputDirectory =
          Directory(path.join(documentsPath, 'ExcelOutput'));
      await outputDirectory.create(recursive: true);
      final excelPath = path.join(outputPath, '$name.xlsx');
      final excelBytes = excel.encode();
      final excelFile = File(excelPath);
      await excelFile.writeAsBytes(excelBytes!);
      debugPrint('Tabla SQLite convertida a Excel: $excelPath');
      return true;
    } else {
      debugPrint('No se seleccionó ninguna carpeta.');
      return false;
    }
  }
}
