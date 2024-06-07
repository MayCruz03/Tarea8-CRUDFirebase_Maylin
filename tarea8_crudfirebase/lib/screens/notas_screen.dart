import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarea8_crudfirebase/models/notas_model.dart';
import 'package:tarea8_crudfirebase/services/notas_service.dart';

class NotasScreen extends StatefulWidget {
  @override
  _NotasScreenState createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  final NotasService _notaService = NotasService();
  String _filtroEstado = 'Todos';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "CRUD Firebase_Maylin",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 7, 120, 148),
          actions: [
            DropdownButton<String>(
              value: _filtroEstado,
              icon: Icon(Icons.filter_list, color: Colors.white),
              dropdownColor: Color.fromARGB(255, 7, 120, 148),
              onChanged: (String? newValue) {
                setState(() {
                  _filtroEstado = newValue!;
                });
              },
              items: <String>[
                'Todos',
                'Creado',
                'Por hacer',
                'Trabajando',
                'Finalizado'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                );
              }).toList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 7, 120, 148),
          onPressed: () {
            _mostrarFormularioNota(context, null);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: StreamBuilder<List<notas>>(
          stream: _notaService.obtenerNotas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay notas'));
            } else {
              final notas = snapshot.data!;
              final notasFiltradas = _filtroEstado == 'Todos'
                  ? notas
                  : notas
                      .where((nota) => nota.estado == _filtroEstado)
                      .toList();
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: notasFiltradas.length,
                itemBuilder: (context, index) {
                  final nota = notasFiltradas[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nota.descripcion,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Fecha: ${DateFormat('yyyy-MM-dd').format(nota.fecha)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Chip(
                                label: Text(nota.estado),
                                backgroundColor: _getEstadoColor(nota.estado),
                              ),
                              SizedBox(width: 4),
                              Chip(
                                label: Text(
                                    nota.importante ? 'Importante' : 'Normal'),
                                backgroundColor:
                                    nota.importante ? Colors.red : Colors.green,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _mostrarFormularioNota(context, nota);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmarEliminar(context, nota.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Creado':
        return Colors.grey;
      case 'Por hacer':
        return Colors.orange;
      case 'Trabajando':
        return Colors.blue;
      case 'Finalizado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _confirmarEliminar(BuildContext context, String notaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Está seguro de que desea eliminar esta nota?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () async {
                await _notaService.eliminarNota(notaId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarFormularioNota(BuildContext context, notas? nota) {
    final TextEditingController descripcionController = TextEditingController(
      text: nota != null ? nota.descripcion : '',
    );
    String estado = nota != null ? nota.estado : 'Creado';
    bool importante = nota != null ? nota.importante : false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: descripcionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Estado',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: estado,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          estado = newValue!;
                        });
                      },
                      items: <String>[
                        'Creado',
                        'Por hacer',
                        'Trabajando',
                        'Finalizado'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Text('Importante',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: importante,
                          onChanged: (bool? value) {
                            setState(() {
                              importante = value!;
                            });
                          },
                        ),
                        Text('Sí'),
                        Radio<bool>(
                          value: false,
                          groupValue: importante,
                          onChanged: (bool? value) {
                            setState(() {
                              importante = value!;
                            });
                          },
                        ),
                        Text('No'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Guardar'),
                          onPressed: () async {
                            final nuevaNota = notas(
                              id: nota != null ? nota.id : '',
                              descripcion: descripcionController.text,
                              fecha: nota != null ? nota.fecha : DateTime.now(),
                              estado: estado,
                              importante: importante,
                            );
                            if (nota != null) {
                              await _notaService.actualizarNota(nuevaNota);
                            } else {
                              await _notaService.agregarNota(nuevaNota);
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
