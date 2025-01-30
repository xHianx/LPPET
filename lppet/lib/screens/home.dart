import 'package:flutter/material.dart';
import 'package:lppet/components/ButtonWithImage.dart';
import 'package:lppet/constants.dart';
import 'package:lppet/screens/adopcion.dart';
import 'package:lppet/screens/donation.dart';
import 'package:lppet/screens/login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        leading: IconButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: Text(
                usuario_loggeado!.email,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8.0,
                  fontFamily: 'LexendDeca',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const CircleAvatar(
            backgroundImage: AssetImage("assets/perfil.png"),
          ),
          const SizedBox(width: 10,)
        ],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ButtonWithImage(
          imagePath: "assets/home/adopcion.png",
          label: 'Adoptar',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AnimalList()),
            );
          },
        ),
        ButtonWithImage(
          imagePath: "assets/home/donacion.png",
          label: 'Donar',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Donation()),
            );
          },
        ),
        ButtonWithImage(
          imagePath: "assets/home/solicitud.png",
          label: 'Solicitudes',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AnimalList()),
            );
          },
        ),
        ButtonWithImage(
          imagePath: "assets/home/usuario.png",
          label: 'Perfil',
          onPressed: () {
            // Navegar a perfil
          },
        ),
        Image.asset("assets/home/perros.png", height: 500,),
      ]),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cerrar sesión"),
          content: const Text("¿Estás seguro de que quieres cerrar sesión?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text("Cerrar sesión"),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                _logout(context); // Llama a la función de cierre de sesión
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    usuario_loggeado = null;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

