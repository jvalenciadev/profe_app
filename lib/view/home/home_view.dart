import 'package:flutter/material.dart';
import '../../res/colors/app_color.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titulo principal
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.primaryColor, AppColor.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido al Programa PROFE',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Descubre los eventos, ofertas académicas y más.',
                    style: TextStyle(
                      color: AppColor.whiteColor.withOpacity(0.8),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            // Sección de Eventos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eventos',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  EventCard(title: 'Conversatorio sobre Educación', dateStart: '15 de Marzo', dateEnd: '16 de Marzo', description: 'Un conversatorio sobre las nuevas tendencias en educación.', imageUrl: 'assets/images/event1.jpg'),
                  EventCard(title: 'Taller de Innovación', dateStart: '20 de Marzo', dateEnd: '22 de Marzo', description: 'Explora las herramientas más innovadoras para tu desarrollo profesional.', imageUrl: 'assets/images/event2.jpg'),
                ],
              ),
            ),

            // Sección de Ofertas Académicas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ofertas Académicas',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OfferCard(title: 'Diplomado en Tecnologías Educativas', description: 'Inicia tu formación en tecnología educativa.', imageUrl: 'assets/images/offer1.jpg', dateStart: 'Marzo', dateEnd: 'Abril'),
                  OfferCard(title: 'Ciclo de Especialización en Pedagogía', description: 'Un ciclo formativo enfocado en pedagogía moderna.', imageUrl: 'assets/images/offer2.jpg', dateStart: 'Abril', dateEnd: 'Mayo'),
                ],
              ),
            ),

            // Sección de Novedades
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Novedades',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  NewsCard(title: 'Nuevo Curso de Matemáticas', description: 'Lanzamiento de nuestro nuevo curso de matemáticas aplicadas.', imageUrl: 'assets/images/news1.jpg', date: '10 de Marzo'),
                  NewsCard(title: 'Apertura de Inscripciones', description: 'Ya están abiertas las inscripciones para el próximo ciclo académico.', imageUrl: 'assets/images/news2.jpg', date: '5 de Marzo'),
                ],
              ),
            ),

            // Sección de Sedes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nuestras Sedes',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SedeCard(
                    imageUrl: 'assets/images/sede1.jpg',
                    title: 'Sede Central',
                    description: 'Ubicada en el centro de la ciudad, con todas las comodidades para nuestros estudiantes.',
                    lat: '18.0159',
                    lon: '-77.2975',
                  ),
                  SedeCard(
                    imageUrl: 'assets/images/sede2.jpg',
                    title: 'Sede Norte',
                    description: 'Nuestra sede norte ofrece espacios modernos y recursos educativos avanzados.',
                    lat: '18.0459',
                    lon: '-77.3175',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String dateStart;
  final String dateEnd;
  final String description;
  final String imageUrl;

  const EventCard({
    required this.title,
    required this.dateStart,
    required this.dateEnd,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            // Imagen de Evento
            Image.asset(
              imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$dateStart - $dateEnd',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Inscribirse',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String dateStart;
  final String dateEnd;

  const OfferCard({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.dateStart,
    required this.dateEnd,
  });

  @override
  Widget build(BuildContext context) {
    return EventCard(
      title: title,
      dateStart: dateStart,
      dateEnd: dateEnd,
      description: description,
      imageUrl: imageUrl,
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String date;

  const NewsCard({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            // Imagen de Novedad
            Image.asset(
              imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SedeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String lat;
  final String lon;

  const SedeCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.lat,
    required this.lon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(imageUrl, width: double.infinity, height: 180, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: AppColor.secondaryColor),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: AppColor.primaryColor),
                const SizedBox(width: 6),
                Text('$lat, $lon', style: TextStyle(fontSize: 14, color: AppColor.primaryTextColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
