import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/evento_model.dart';
import '../../models/persona_model.dart';
import '../../res/colors/app_color.dart';
import '../../utils/utils.dart';
import '../../view_models/controller/home/evento_view_models.dart';

class EventoFormularioScreen extends StatefulWidget {
  const EventoFormularioScreen({Key? key}) : super(key: key);

  @override
  State<EventoFormularioScreen> createState() => _EventoFormularioScreenState();
}

class _EventoFormularioScreenState extends State<EventoFormularioScreen> {
  late EventoModel evento;
  late Persona persona;

  Department? _selectedDepartment;
  String? _selectedModality;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    evento = args['evento'] as EventoModel;
    persona = args['persona'] as Persona;

    // Inicializar selección de departamento por abreviación
    _selectedDepartment = departmentList.firstWhere(
      (d) => d.name == persona.depNombre,
      orElse: () => departmentList.first,
    );

    // Modalidades del evento
    final mods = evento.modalidades ?? [];
    _selectedModality = mods.isNotEmpty ? mods.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(evento.eveNombre ?? 'Formulario'),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Datos personales readonly
              _buildReadonlyField('Cédula de Identidad', persona.ci.toString()),
              _buildReadonlyField('Nombre', '${persona.nombre1} ${persona.apellido1} ${persona.apellido2}'),
              _buildReadonlyField('Correo', persona.correo ?? ''),
              _buildReadonlyField('Celular', persona.celular ?? ''),
              _buildReadonlyField('Fecha de Nacimiento', persona.fechaNacimiento ?? ''),

              // Modalidad
              const Text('Modalidad', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: _selectedModality,
                items: (evento.modalidades ?? [])
                    .map((mod) => DropdownMenuItem(value: mod, child: Text(mod)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedModality = val),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.grey3Color,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              // Departamento
              const Text('Departamento', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 4),
              DropdownButtonFormField<Department>(
                value: _selectedDepartment,
                items: departmentList
                    .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedDepartment = val),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.grey3Color,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Enviar formulario
                    final data = {
                      'eve_id': evento.eveId,
                      'per_ci': persona.ci,
                      'per_modalidad': _selectedModality,
                      'per_departamento': _selectedDepartment?.id,
                    };
                    Get.find<EventoController>().eventoInscripcionPost(data);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: const Text('Enviar', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadonlyField(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            enabled: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColor.grey3Color,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
}
