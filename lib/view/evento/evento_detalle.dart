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
            final String bannerUrl =
                isPortrait
                    ? "${AppUrl.baseImage}/storage/evento_afiches/${evento.eveAfiche}"
                    : "${AppUrl.baseImage}/storage/evento_banners/${evento.eveBanner}";

            return Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: bannerUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) => Center(
                        child: Icon(
                          FontAwesomeIcons.image,
                          size: 50,
                          color: AppColor.grey2Color,
                        ),
                      ),
                ),
                // TIPO DE EVENTO (etNombre)
                if (evento.etNombre != null)
                  Positioned(
                    top: 50,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor.withOpacity(0.8),
                        border: Border.all(color: AppColor.secondaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            FontAwesomeIcons.tag,
                            size: 16,
                            color: AppColor.secondaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            evento.etNombre!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.mina,
                              color: AppColor.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                DraggableScrollableSheet(
                  initialChildSize: isPortrait ? 0.59 : 0.50,
                  minChildSize: isPortrait ? 0.59 : 0.50,
                  maxChildSize: isPortrait ? 0.90 : 0.90,
                  builder: (context, scrollController) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 8),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TARJETA PRINCIPAL DEL EVENTO
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TÍTULO DEL EVENTO
                                Text(
                                  evento.eveNombre ?? 'Sin título',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.mina,
                                    color: AppColor.primaryColor,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // FECHA Y LUGAR
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.calendarDays,
                                      size: 16,
                                      color: AppColor.greyColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      evento.eveFecha ?? 'Sin fecha',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: AppFonts.mina,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      FontAwesomeIcons.mapPin,
                                      size: 16,
                                      color: AppColor.greyColor,
                                    ),
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

                                const SizedBox(height: 10),

                                // MODALIDADES
                                if (evento.modalidades != null &&
                                    evento.modalidades!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      
                               if (evento.eveInsHoraAsisHabilitado != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.clock,
                                color: AppColor.primaryColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Hora: ${formatoHoraAmPm(evento.eveInsHoraAsisHabilitado)} - ${formatoHoraAmPm(evento.eveInsHoraAsisDeshabilitado)}',
                                style: const TextStyle(
                                  fontFamily: AppFonts.mina,
                                  fontSize: 16
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.style,
                                            size: 18,
                                            color: AppColor.primaryColor,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Modalidades',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: AppFonts.mina,
                                              color: AppColor.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children:
                                            (evento.modalidades as List<String>).map((
                                              modalidad,
                                            ) {
                                              return Chip(
                                                label: Text(
                                                  modalidad,
                                                  style: const TextStyle(
                                                    color: AppColor.whiteColor,
                                                    fontFamily: AppFonts.mina,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    AppColor.secondaryColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ), // Espaciado interno
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        20,
                                                      ), // Bordes más suaves
                                                  side: BorderSide(
                                                    color: AppColor
                                                        .secondaryColor
                                                        .withOpacity(
                                                          0.6,
                                                        ), // Sutil borde
                                                    width: 1,
                                                  ),
                                                ),
                                                elevation: 4,
                                                shadowColor: AppColor
                                                    .secondaryColor
                                                    .withOpacity(0.9),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),

                                const SizedBox(height: 10),
],
                            ),
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
