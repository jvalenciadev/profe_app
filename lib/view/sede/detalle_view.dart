import 'package:flutter/material.dart';

class SedeDetallesScreen extends StatelessWidget {
  final dynamic sede;

  const SedeDetallesScreen({super.key, required this.sede});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Sede'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _buildRow("Departamento", sede.depNombre),
            _buildRow("Nombre", sede.sedeNombre),
            _buildRow("Contacto", sede.sedeContacto1.toString()),
            _buildRow("Horario", sede.sedeHorario),
            _buildRow("Turno", sede.sedeTurno),
            _buildRow(
              "Estado",
              sede.sedeEstado == "activo" ? "🟢 Abierto" : "🔴 Cerrado",
              color: sede.sedeEstado == "activo" ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildRow(String label, String value, {Color? color}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: TextStyle(color: color ?? Colors.black),
          ),
        ),
      ],
    );
  }
}
