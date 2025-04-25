import 'package:flutter/material.dart';
import 'package:programa_profe/res/colors/app_color.dart';
import 'package:programa_profe/res/fonts/app_fonts.dart';
import 'package:tab_container/tab_container.dart';

class Offer {
  final String image;
  final String title;
  final String description;
  final double cost;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime classStartDate;

  Offer({
    required this.image,
    required this.title,
    required this.description,
    required this.cost,
    required this.startDate,
    required this.endDate,
    required this.classStartDate,
  });
}

class OffersScreen extends StatelessWidget {
  final List<Offer> allOffers = [
    Offer(
      image: 'https://www.w3schools.com/w3images/lights.jpg',
      title: 'Ciclo Formativo A',
      description: 'Descripción del ciclo formativo A',
      cost: 500.0,
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 6, 1),
      classStartDate: DateTime(2025, 7, 1),
    ),
    Offer(
      image: 'https://www.w3schools.com/w3images/fjords.jpg',
      title: 'Diplomado en Ciencias',
      description: 'Descripción del diplomado en ciencias',
      cost: 700.0,
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 7, 1),
      classStartDate: DateTime(2025, 8, 1),
    ),
    Offer(
      image: 'https://www.w3schools.com/w3images/mountains.jpg',
      title: 'Especialidad en Matemáticas',
      description: 'Descripción de la especialidad en matemáticas',
      cost: 600.0,
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2025, 8, 1),
      classStartDate: DateTime(2025, 9, 1),
    ),
  ];

  List<Offer> filterBy(String category) {
    return allOffers.where((offer) => offer.title.contains(category)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tabTitles = ['CICLOS FORMATIVOS', 'DIPLOMADOS', 'ESPECIALIDADES'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
      child: TabContainer(
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
        colors: [AppColor.grey3Color, AppColor.grey3Color, AppColor.grey3Color],
        tabs: tabTitles.map((e) => Text(e)).toList(),
        children:
            tabTitles.map((category) {
              List<Offer> offers = filterBy(
                category == 'CICLOS FORMATIVOS'
                    ? 'Ciclo'
                    : category == 'DIPLOMADOS'
                    ? 'Diplomado'
                    : 'Especialidad',
              );
              return ListView.builder(
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
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
                                  offer.image,
                                  height: 180,
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
                                          'Costo: \$${offer.cost}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Inscripción: ${offer.startDate.toLocal().toString().split(" ")[0]} - ${offer.endDate.toLocal().toString().split(" ")[0]}',
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
                            offer.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            offer.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Inicio de clases: ${offer.classStartDate.toLocal()}',
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
      ),
    );
  }
}
