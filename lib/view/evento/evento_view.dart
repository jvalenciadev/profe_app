import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../data/response/status.dart';
import '../../res/app_url/app_url.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/routes/routes_name.dart';
import '../../utils/utilidad.dart';
import '../../view_models/controller/home/home_view_models.dart';

class EventScreen extends StatelessWidget {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (homeController.eventosStatus.value) {
          case Status.LOADING:
            return Center(child: loading());
          case Status.ERROR:
            return buildErrorWidget(homeController.refreshAll);
          case Status.COMPLETED:
            final events = homeController.eventoList.value.respuesta!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: events.length,
              itemBuilder: (_, i) {
                final n = events[i];
                return GestureDetector(
                  onTap: () => Get.toNamed(RouteName.eventoDetalleView, arguments: n),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 350,
                    child: Stack(
                      children: [
                        // Fondo difuminado
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: "${AppUrl.baseImage}/storage/evento_afiches/${n.eveAfiche}",
                              fit: BoxFit.fill,
                              colorBlendMode: BlendMode.darken,
                              color: Colors.black12,
                              placeholder: (_, __) => Container(color: AppColor.grey3Color),
                              errorWidget: (_, __, ___) => Container(color: AppColor.grey3Color),
                            ),
                          ),
                        ),
                        // Tarjeta frontal
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 210,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.fromLTRB(15,15,15,5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Título y fecha
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        n.eveNombre ?? '-',
                                        style: TextStyle(
                                          fontFamily: AppFonts.mina,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.primaryColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColor.secondaryColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        n.eveFecha ?? '-',
                                        style: TextStyle(
                                          fontFamily: AppFonts.mina,
                                          fontSize: 12,
                                          color: AppColor.secondaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                // Iconos informativos
                                Row(
                                  children: [
                                    Icon(FontAwesomeIcons.mapMarkerAlt, size: 14, color: AppColor.primaryColor),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        n.eveLugar ?? 'Sin especificar',
                                        style: TextStyle(fontSize: 13, color: AppColor.blackColor,fontFamily: AppFonts.mina),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                
                                // MODALIDADES
                                if (n.modalidades != null &&
                                    n.modalidades!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (n.eveInsHoraAsisHabilitado !=
                                          null)
                                         Row(
                                            children: [
                                              const Icon(
                                                FontAwesomeIcons.clock,
                                                size: 14,
                                                color: AppColor.primaryColor,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Hora: ${formatoHoraAmPm(n.eveInsHoraAsisHabilitado!)} - ${formatoHoraAmPm(n.eveInsHoraAsisDeshabilitado!)}',
                                                style: const TextStyle(
                                                  fontFamily: AppFonts.mina,
                                                  color: AppColor.blackColor,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                        ),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 0,
                                        children:
                                            (n.modalidades as List<String>).map((
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
                                                    fontSize: 14
                                                  ),
                                                ),
                                                backgroundColor:
                                                    AppColor.secondaryColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
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
                                                elevation: 2,
                                                shadowColor: AppColor
                                                    .secondaryColor
                                                    .withOpacity(0.9),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child:TextButton.icon(
                                              style: TextButton.styleFrom(
                                                backgroundColor: AppColor
                                                    .primaryColor
                                                    .withValues(alpha: 0.1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10,
                                                    ),
                                              ),
                                              icon: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 16,
                                                color: AppColor.primaryColor,
                                              ),
                                              label: const Text(
                                                "Ver más",
                                                style: TextStyle(
                                                  color: AppColor.primaryColor,
                                                  fontFamily: AppFonts.mina,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14
                                                ),
                                              ),
                                              onPressed: () => Get.toNamed(RouteName.eventoDetalleView, arguments: n),
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          default:
            return SizedBox();
        }
      }),
    );
  }
}
