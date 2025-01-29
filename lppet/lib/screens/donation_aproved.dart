import 'package:flutter/material.dart';
import 'package:lppet/constants.dart';
import 'package:lppet/screens/home.dart';

class DonationAproved extends StatelessWidget {
  const DonationAproved({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Contenedor inferior con el mismo color de fondo que la imagen del corgi
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                  color: textColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  )), // Mismo color de fondo que la imagen del corgi
            ),
          ),
          // Contenido principal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  "Gracias por tu donación!",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontFamily: 'LexendDeca',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Image.asset(
                  'assets/gato_gracias.png', // Imagen del icono central de la patita
                  height: 300,
                ),
                const SizedBox(height: 20),
                Text(
                  "Donación Exitosa!",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontFamily: 'LexendDeca',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "Gracias por tu generosa contribucion! Gracias a ti, más perros y gatos tendrán una vida mejor. Todos los animales del refugio te mandan saludos!",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontFamily: 'LexendDeca',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  'assets/gato_saludando.png', // Imagen del corgi, se recomienda que sea PNG con transparencia
                  height: 250,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
