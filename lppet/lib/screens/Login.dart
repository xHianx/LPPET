import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lppet/components/MyButton.dart';
import 'package:lppet/components/MyInputField.dart';
import 'package:lppet/constants.dart';
import 'package:lppet/models/usuario.dart';
import 'package:lppet/screens/home.dart';
import 'package:lppet/screens/signup.dart';
// import 'package:lppet/screens/create_account.dart';
// import 'package:lppet/screens/main_window.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> logIn(String email, String password) async {
    final url = Uri.parse("http://127.0.0.1:5000/iniciarSesion");
    final bodyPeticion = jsonEncode({
      "email": email,
      "password": password,
    });
    final respuesta = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Define que el contenido es JSON
      },
      body: bodyPeticion,
    );
    if (respuesta.statusCode == 200) {
      //solicitud exitosa
      final respuestaJson = await jsonDecode(respuesta.body);
      usuario_loggeado = Usuario.fromJson(respuestaJson['usuario']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('LogIn exitoso')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
      //navego a la ventana por que el acceso fue exitoso
    } else if (respuesta.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error del servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.1),
          child: Center(
            child: Column(
              children: [
                Text(
                  "¡Bienvenido!",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: screenWidth * 0.07,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                  
                ),
                const SizedBox(height: 20),
                Image.asset(
                  "assets/perrito.jpg",
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  height: screenHeight * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08, vertical: 20),
                    child: Column(
                      children: [
                        MyInputField(
                          hint: "Correo electrónico",
                          controller: _emailController,
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        MyInputField(
                          hint: "Contraseña",
                          controller: _passwordController,
                        ),
                        SizedBox(height: screenHeight * 0.08),
                        MyButton(
                          label: "Iniciar Sesión",
                          onTap: () async {
                            await logIn(_emailController.text,
                                _passwordController.text);
                          },
                          buttonColor: Colors.teal,
                          labelColor: Colors.white,
                          cornerRadius: 20,
                          shadowIntensity: 6.0,
                        ),
                        const SizedBox(height: 20),
                        MyButton(
                          label: "Registrarse",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup()),
                            );
                          },
                          buttonColor: Colors.grey[400]!,
                          labelColor: Colors.black,
                          cornerRadius: 20,
                          shadowIntensity: 4.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
