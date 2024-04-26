import 'package:get/instance_manager.dart';
import 'package:inventariosnew/data/datasource_excel/excel_repository_impl.dart';
import 'package:inventariosnew/data/datasource_local/local_respository_impl.dart';
import 'package:inventariosnew/data/datasource_sqflite/database_repository_impl.dart';
import 'package:inventariosnew/domain/repository/database_repository_interface.dart';
import 'package:inventariosnew/domain/repository/excel_repository_interface.dart';
import 'package:inventariosnew/domain/repository/local_repository_interface.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalRepositoryInterface>(
      () => LocalRepositoryImpl(),
    );
    Get.lazyPut<DatabaseRepositoryInterface>(
      () => DatabaseRepositoryImpl(),
    );
    Get.lazyPut<ExcelRepositoryInterface>(
      () => ExcelRepositoryImpl(),
    );
  }
}
