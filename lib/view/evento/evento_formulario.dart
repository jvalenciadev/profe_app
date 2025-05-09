import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/persona_model.dart';
import '../../res/colors/app_color.dart';

class EventoFormularioScreen extends StatelessWidget {
  const EventoFormularioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final evento = args['evento'];
    final Persona persona = args['persona'];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Cabecera con el nombre del evento
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: AppColor.primaryColor,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  evento.eveNombre ?? 'Evento',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
              ),
            ),

            // Formulario con campos pre-llenados y deshabilitados
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildReadonlyField(
                    'Cédula de Identidad',
                    persona.ci.toString(),
                  ),
                  _buildReadonlyField(
                    'Nombre',
                    '${persona.nombre1} ${persona.apellido1} ${persona.apellido2}',
                  ),
                  _buildReadonlyField('Correo', persona.correo ?? ''),
                  _buildReadonlyField('Celular', persona.celular ?? ''),
                  _buildReadonlyField(
                    'Fecha de Nacimiento',
                    persona.fechaNacimiento ?? '',
                  ),
                  _buildReadonlyField('Modalidad', persona.pmNombre ?? ''),
                  _buildReadonlyField('Departamento', persona.depNombre ?? ''),
                  // Aquí podrías agregar más campos si los tienes en el modelo...
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                      child: const Text(
                        'Volver',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadonlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.grey3Color,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
