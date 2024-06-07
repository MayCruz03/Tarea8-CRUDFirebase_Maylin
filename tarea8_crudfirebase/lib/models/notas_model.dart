import 'package:cloud_firestore/cloud_firestore.dart';

class notas {
  String id;
  String descripcion;
  DateTime fecha;
  String estado;
  bool importante;

  notas({
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.estado,
    required this.importante,
  });

  factory notas.fromFirestore(DocumentSnapshot nota) {
    Map<String, dynamic> data = nota.data() as Map<String, dynamic>;
    return notas(
      id: nota.id,
      descripcion: data['descripcion'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
      estado: data['estado'] ?? 'Creado',
      importante: data['importante'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'descripcion': descripcion,
      'fecha': fecha,
      'estado': estado,
      'importante': importante,
    };
  }
}
