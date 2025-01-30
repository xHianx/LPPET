import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lppet/components/MyButton.dart';
import 'package:lppet/components/MyInputField.dart';
import 'package:lppet/constants.dart';
import 'package:lppet/models/usuario.dart';
import 'package:lppet/screens/home.dart';
import 'package:dio/dio.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  CreateAcountState createState() => CreateAcountState();
}

class CreateAcountState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController email = TextEditingController();
    final TextEditingController userName = TextEditingController();
    final TextEditingController nombre = TextEditingController();
    final TextEditingController apellido = TextEditingController();
    final TextEditingController ocupacion = TextEditingController();
    final TextEditingController password = TextEditingController();

    @override
    void dispose() {
      email.dispose();
      userName.dispose();
      nombre.dispose();
      apellido.dispose();
      ocupacion.dispose();
      password.dispose();
      super.dispose();
    }

    void showError(String errorMessage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error!"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void showModal(String okMessage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Información"),
            content: Text(okMessage),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
              ),
            ],
          );
        },
      );
    }

    Future<int> createAccount() async {
      try {
        if (email.text.isEmpty || password.text.isEmpty) {
          showError("El email y la contraseña no pueden estar vacíos.");
          return 400;
        }

        final response = await Dio().post(
          'http://127.0.0.1:5000/nuevoUsuario',
          data: {"email": email.text.trim(), "password": password.text.trim()},
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          try {
            final respuestaJson = response.data;
            usuario_loggeado = Usuario.fromJson(respuestaJson['usuario']);
            showModal("Cuenta creada con éxito");
            return response.statusCode!;
          } catch (e) {
            showError("Error al procesar la respuesta del servidor.");
            return 500;
          }
        } else {
          showError("Error al crear la cuenta (${response.statusCode}).");
          return response.statusCode!;
        }
      } catch (e) {
        print("Error: $e");
        showError("No se pudo conectar con el servidor.");
        return 400;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.1),
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: Navigator.of(context).pop,
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: secundaryColor,
                            )),
                        SizedBox(
                          width: screenWidth * 0.1,
                        ),
                        Text(
                          "Crea tu cuenta",
                          style: TextStyle(
                            color: textColor,
                            fontSize: screenWidth * 0.08,
                            fontFamily: 'LexendDeca',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.2),
                  Container(
                    width: screenWidth,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                      color: textColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.04),
                        MyInputField(
                          hint: "Email",
                          controller: email,
                        ),
                        MyInputField(
                          hint: "Usuario",
                          controller: userName,
                        ),
                        MyInputField(
                          hint: "Nombre",
                          controller: nombre,
                        ),
                        MyInputField(
                          hint: "Apellido",
                          controller: apellido,
                        ),
                        MyInputField(
                          hint: "Ocupación",
                          controller: ocupacion,
                        ),
                        MyInputField(
                          hint: "Contraseña",
                          controller: password,
                        ),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                MyButton(
                                  label: "     Registrarse    ",
                                  onTap: () async {
                                    if (email.text.isEmpty ||
                                        userName.text.isEmpty ||
                                        nombre.text.isEmpty ||
                                        apellido.text.isEmpty ||
                                        ocupacion.text.isEmpty ||
                                        password.text.isEmpty) {
                                      showError(
                                          "Se deben llenar todos los campos.");
                                    } else {
                                      int statusCode = await createAccount();
                                      if (statusCode == 201) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Home()),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
