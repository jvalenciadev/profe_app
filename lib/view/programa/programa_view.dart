import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:programa_profe/res/colors/app_color.dart';
import 'package:programa_profe/res/fonts/app_fonts.dart';
import 'package:tab_container/tab_container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/response/status.dart';
import '../../models/programa_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/routes/routes_name.dart';
import '../../utils/utilidad.dart';
import '../../view_models/controller/home/home_view_models.dart';


class OffersScreen extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabTitles = ['CICLOS FORMATIVOS', 'DIPLOMADOS', 'ESPECIALIDADES'];

    return Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 0),
          child: Obx(() {
            switch (homeController.programasStatus.value) {
              case Status.LOADING:
                return loading();
              case Status.ERROR:
                return buildErrorWidget(homeController.refreshAll);
              case Status.COMPLETED:
                final fullList = homeController.programaList.value.respuesta!;
                List filterBy(String category) {
                  return fullList
                      .where((offer) => offer.proTipNombre!.contains(category))
                      .toList();
                }

                return TabContainer(
                  tabEdge: TabEdge.top,
                  selectedTextStyle: const TextStyle(
                    fontFamily: AppFonts.mina,
                    color: AppColor.primaryColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedTextStyle: const TextStyle(
                    fontFamily: AppFonts.mina,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0,
                  ),
                  colors: List.generate(
                    tabTitles.length,
                    (_) => AppColor.grey3Color,
                  ),
                  tabs: tabTitles.map((e) => Text(e)).toList(),
                  children:
                      tabTitles.map((category) {
                        final filteredList = filterBy(
                          category == 'CICLOS FORMATIVOS'
                              ? 'Ciclo'
                              : category == 'DIPLOMADOS'
                              ? 'Diplomado'
                              : 'Especialidad',
                        );
                        if (filteredList.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'No hay ${category.toLowerCase()} disponibles',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: AppFonts.mina,
                                  color: AppColor.greyColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: filteredList.map((programa) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 5,
                              ),
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            "${AppUrl.baseImage}/storage/programa_afiches/${programa.proAfiche}",
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Container(
                                              height: 250,
                                              color: AppColor.grey3Color,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color:
                                                          AppColor.grey2Color,
                                                    ),
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => Container(
                                              height: 250,
                                              color: AppColor.grey3Color,
                                              child: const Icon(
                                                FontAwesomeIcons.image,
                                                size: 50,
                                                color: AppColor.grey2Color,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${programa.proTipNombre} en ${programa.proNombre}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: AppFonts.mina,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.greyColor,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildInscripcionButton(programa),
                                            Pulse(
                                              from: 1,
                                              to: 1.02,
                                              infinite: true,
                                              child: TextButton.icon(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: AppColor
                                                      .primaryColor
                                                      .withValues(alpha: 0.1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 10,
                                                      ),
                                                ),
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 16,
                                                  color: AppColor.primaryColor,
                                                ),
                                                label: const Text(
                                                  "Ver más",
                                                  style: TextStyle(
                                                    color:
                                                        AppColor.primaryColor,
                                                    fontFamily: AppFonts.mina,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Get.toNamed(
                                                    RouteName.programaDetalle,
                                                    arguments: programa,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),);
                        
                      }).toList(),
                );
              case Status.IDLE:
                // TODO: Handle this case.
                throw UnimplementedError();
            }
          }),
    );
  }
}

Widget _buildInscripcionButton(ProgramaModel prog) {
  // Parsear fechas
  final inicio = DateTime.parse(prog.proFechaInicioInscripcion!);
  final fin = DateTime.parse(prog.proFechaFinInscripcion!);
  final now = DateTime.now();

  // Solo mostrar si estamos en el rango de inscripción
  if (now.isAfter(inicio) && now.isBefore(fin)) {
    final uri = Uri.parse(
      'https://profe.minedu.gob.bo/ofertas-academicas/inscripcion/${prog.proId}',
    );

    return Pulse(
      from: 1,
      to: 1.02,
      infinite: true,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        icon: const Icon(
          Icons.edit_calendar_outlined,
          size: 18,
          color: AppColor.whiteColor,
        ),
        label: const Text(
          "Inscríbete",
          style: TextStyle(
            fontFamily: AppFonts.mina,
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () async {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            Get.snackbar(
              "Error",
              "No se pudo abrir el formulario de inscripción.",
              backgroundColor: AppColor.primaryColor,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
      ),
    );
  }

  // Fuera de fechas de inscripción, no mostrar nada
  return const SizedBox.shrink();
}
