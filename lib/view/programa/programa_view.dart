import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:programa_profe/res/colors/app_color.dart';
import 'package:programa_profe/res/fonts/app_fonts.dart';
import 'package:tab_container/tab_container.dart';

import '../../data/response/status.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import '../../res/components/internet_exceptions_widget.dart';
import '../../utils/preloader.dart';
import '../../view_models/controller/home/home_view_models.dart';
class OffersScreen extends StatelessWidget {
  final homeController = Get.find<HomeController>();

  Widget _buildErrorWidget() {
    if (homeController.error.value == 'No internet') {
      return InterNetExceptionWidget(onPress: homeController.refreshApi);
    } else {
      return GeneralExceptionWidget(onPress: homeController.refreshApi);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabTitles = ['CICLOS FORMATIVOS', 'DIPLOMADOS', 'ESPECIALIDADES'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
      child: Obx(() {
        switch (homeController.rxRequestStatus.value) {
          case Status.LOADING:
            return LoadingContainer();
          case Status.ERROR:
            return _buildErrorWidget();
          case Status.COMPLETED:
            if (homeController.programaList.value.respuesta == null ||
                homeController.programaList.value.respuesta!.isEmpty) {
              return Center(
                child: Text(
                  "No hay sedes disponibles",
                  style: TextStyle(fontFamily: AppFonts.mina),
                ),
              );
            }

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
              colors: List.generate(tabTitles.length, (_) => AppColor.grey3Color),
              tabs: tabTitles.map((e) => Text(e)).toList(),
              children: tabTitles.map((category) {
                final filteredList = filterBy(
                  category == 'CICLOS FORMATIVOS'
                      ? 'Ciclo'
                      : category == 'DIPLOMADOS'
                          ? 'Diplomado'
                          : 'Especialidad',
                );

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final programa = filteredList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Image.network(
                                    "${AppUrl.baseImage}/storage/programa_afiches/${programa.proAfiche}",
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      color: Colors.black.withOpacity(0.5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Costo: \$${programa.proCosto}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            'Inscripción: ${programa.proFechaInicioInscripcion}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              programa.proNombre,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              programa.proContenido,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Inicio de clases: ${programa.createdAt}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
        }
      }),
    );
  }
}
