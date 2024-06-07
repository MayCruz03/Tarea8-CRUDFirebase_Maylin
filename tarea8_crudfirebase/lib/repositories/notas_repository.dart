import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notas_model.dart';

class NotasRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> agregarNota(notas nota) async {
    await _db.collection('collection_notas').add(nota.toFirestore());
  }

  Stream<List<notas>> obtenerNotas() {
    return _db.collection('collection_notas').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => notas.fromFirestore(doc)).toList());
  }

  Future<notas?> obtenerNotaPorId(String id) async {
    final doc = await _db.collection('collection_notas').doc(id).get();
    if (doc.exists) {
      return notas.fromFirestore(doc);
    }
    return null;
  }

  Future<void> actualizarNota(notas nota) async {
    await _db
        .collection('collection_notas')
        .doc(nota.id)
        .update(nota.toFirestore());
  }

  Future<void> eliminarNota(String id) async {
    await _db.collection('collection_notas').doc(id).delete();
  }
}
