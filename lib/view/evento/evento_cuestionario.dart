
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/response/api_response.dart';
import '../../models/evento_model.dart';
import '../../models/persona_model.dart';
import '../../view_models/controller/evento/evento_cuestionario_models.dart';

class EventoCuestionarioScreen extends StatefulWidget {
  const EventoCuestionarioScreen({super.key});

  @override
  State<EventoCuestionarioScreen> createState() => _EventoCuestionarioScreenState();
}

class _EventoCuestionarioScreenState extends State<EventoCuestionarioScreen> {
  late EventoModel evento;
  late Persona persona;
  final CuestionarioController _ctrl = Get.find<CuestionarioController>();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    evento = EventoModel.fromJson(args['evento']);
    persona = Persona.fromJson(args['persona']);
    _ctrl.cuestionarioResponse.value = ApiResponse.loading();
    _ctrl.eventoCuestionarioPost({
      "eve_id": evento.eveId,
      "per_ci": persona.ci
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
