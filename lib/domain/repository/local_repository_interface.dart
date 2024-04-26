abstract class LocalRepositoryInterface {
  Future<bool> guardarToken({required String authToken});
  Future<bool> cerrarsession();
  Future<String?> usartoken();
  Future<void> guardarfechacad({required String fechacad});
  Future<String?> compararfechacad();
  Future<void> guardarlicenciasusadas({required List<String> licenciasusadas});
  Future<List<String>?> mostrarlaslicencias();
  Future<void> guardaropciondeedit({required bool opcionEdit});
  Future<bool> usarOpcionEdit();
}
