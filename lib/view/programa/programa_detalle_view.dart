import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:programa_profe/models/home/programa_id_model.dart';
import '../../data/response/status.dart';
import '../../models/programa_model.dart';
import '../../res/app_url/app_url.dart';
import '../../view_models/controller/programa/programa_view_model.dart';

class ProgramaDetalleView extends StatefulWidget {
  const ProgramaDetalleView({super.key});

  @override
  State<ProgramaDetalleView> createState() => _ProgramaDetalleViewState();
}

class _ProgramaDetalleViewState extends State<ProgramaDetalleView> {
  final _controller = Get.find<ProgramaController>();
  late final ProgramaModel _programa;
  late final String _proId;

  @override
  void initState() {
    super.initState();
    // Recibimos el objeto ProgramaModel (con proId) desde la ruta
    _programa = Get.arguments as ProgramaModel;
    _proId = _programa.proId.toString();
    // Disparamos la carga de detalle
    _controller.loadProgramas(_proId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final resp = _controller.programaId.value.respuesta;
          return Text(resp?.programa?.proNombreAbre ?? 'Detalle Programa');
        }),
      ),
      body: Obx(() {
        switch (_controller.programaStatus.value) {
          case Status.LOADING:
            return const Center(child: CircularProgressIndicator());
          case Status.ERROR:
            return Center(
              child: Text(
                'Error: ${_controller.error.value}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          case Status.COMPLETED:
            final data = _controller.programaId.value.respuesta!;
            return _buildContent(context, data);
          case Status.IDLE:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      }),
    );
  }

  Widget _buildContent(BuildContext context, Respuesta data) {
    final prog = data.programa!;
    final sedes = data.programaSedeTurno ?? [];
    final galerias = data.galeriasPorPrograma ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // --- Datos básicos ---
        Text(prog.proNombre!,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Código: ${prog.proCodigo}'),
        Text('Carga horaria: ${prog.proCargaHoraria} horas'),
        Text('Costo: ${prog.proCosto} Bs.'),
        const Divider(height: 24),

        // --- Sedes y turnos ---
        Text('Sedes y Turnos',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...sedes.map((sede) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(sede.sedeNombre ?? '—'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Depto.: ${sede.depNombre}'),
                    Text('Contacto: ${sede.sedeContacto1 ?? 'N/A'}'),
                    Text('Turnos: ${sede.programaturno}'),
                  ],
                ),
              ),
            )),

        const Divider(height: 24),

        // --- Restricción ---
        Text('Restricción',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
       

        const Divider(height: 24),

        // --- Galería de imágenes ---
        Text('Galería',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (galerias.isEmpty)
          const Text('No hay imágenes disponibles.')
        else
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: galerias.length,
              itemBuilder: (_, i) {
                final g = galerias[i];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          '${AppUrl.baseImage}/storage/galeria/${g.galeriaImagen}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      g.sedeNombre ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                );
              },
            ),
          ),
      ]),
    );
  }
}
