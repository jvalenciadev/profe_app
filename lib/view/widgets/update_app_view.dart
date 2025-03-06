import 'package:flutter/material.dart';

class UpdateAppView extends StatelessWidget {
  const UpdateAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualización necesaria'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Tu versión de la app está desactualizada!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para redirigir a la tienda de apps (Google Play o App Store)
                // Puedes usar el paquete url_launcher para abrir la URL de la tienda
                // launch('https://play.google.com/store/apps/details?id=com.miapp');
              },
              child: Text('Actualizar ahora'),
            ),
          ],
        ),
      ),
    );
  }
}
