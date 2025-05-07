import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/app_url/app_url.dart';
import '../../utils/utilidad.dart';

class EventDetalleScreen extends StatelessWidget {
  const EventDetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final evento = Get.arguments;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;
            final String bannerUrl = isPortrait
                ? "${AppUrl.baseImage}/storage/evento_afiches/${evento.eveAfiche}"
                : "${AppUrl.baseImage}/storage/evento_banners/${evento.eveBanner}";

            return Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: bannerUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(FontAwesomeIcons.image,
                        size: 50, color: AppColor.grey2Color),
                  ),
                ),

                DraggableScrollableSheet(
                  initialChildSize: isPortrait ? 0.65 : 0.50,
                  minChildSize: isPortrait ? 0.58 : 0.50,
                  maxChildSize: isPortrait ? 0.95 : 0.90,
                  builder: (context, scrollController) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 8),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (evento.modalidades != null &&
                                evento.modalidades!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Modalidades',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppFonts.mina,
                                        color: AppColor.blackColor,
                                      )),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: evento.modalidades!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Chip(
                                            label: Text(
                                              evento.modalidades![index],
                                              style: const TextStyle(
                                                  color: AppColor.whiteColor,
                                                  fontFamily: AppFonts.mina),
                                            ),
                                            backgroundColor:
                                                AppColor.secondaryColor,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 20),

                            // Título
                            Text(
                              evento.eveNombre ?? 'Sin título',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.mina,
                                color: AppColor.blackColor,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Fecha, Lugar
                            Row(
                              children: [
                                const Icon(FontAwesomeIcons.calendarDays,
                                    size: 18, color: AppColor.greyColor),
                                const SizedBox(width: 6),
                                Text(
                                  evento.eveFecha ?? 'Sin fecha',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: AppFonts.mina,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(FontAwesomeIcons.mapPin,
                                    size: 18, color: AppColor.greyColor),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    evento.eveLugar ?? 'Sin lugar',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: AppFonts.mina,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Tipo de evento
                            if (evento.etNombre != null)
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.bolt,
                                      size: 18, color: AppColor.greyColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    evento.etNombre,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFonts.mina,
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 16),

                            // Horarios
                            if (evento.eveInsHoraAsisHabilitado != null ||
                                evento.eveInsHoraAsisDeshabilitado != null)
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.clock,
                                      size: 18, color: AppColor.greyColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    "De ${evento.eveInsHoraAsisHabilitado ?? '-'} a ${evento.eveInsHoraAsisDeshabilitado ?? '-'}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: AppFonts.mina,
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 16),

                            // Total inscritos
                            if (evento.eveTotalInscrito != null)
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.users,
                                      size: 18, color: AppColor.greyColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Inscritos: ${evento.eveTotalInscrito}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: AppFonts.mina,
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 20),

                            // Descripción
                            if (evento.eveDescripcion != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  mostrarHtml(evento.eveDescripcion!),
                                  const SizedBox(height: 20),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Botón volver
                Positioned(
                  top: 16,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
