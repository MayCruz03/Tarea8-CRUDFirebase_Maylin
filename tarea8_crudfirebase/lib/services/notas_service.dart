import 'package:tarea8_crudfirebase/models/notas_model.dart';
import 'package:tarea8_crudfirebase/repositories/notas_repository.dart';

class NotasService {
  final NotasRepository _repository = NotasRepository();

  Future<void> agregarNota(notas nota) async {
    await _repository.agregarNota(nota);
  }

  Stream<List<notas>> obtenerNotas() {
    return _repository.obtenerNotas();
  }

  Future<notas?> obtenerNotaPorId(String id) async {
    return await _repository.obtenerNotaPorId(id);
  }

  Future<void> actualizarNota(notas nota) async {
    await _repository.actualizarNota(nota);
  }

  Future<void> eliminarNota(String id) async {
    await _repository.eliminarNota(id);
  }
}
