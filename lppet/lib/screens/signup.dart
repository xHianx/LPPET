import 'package:flutter/material.dart';
import 'package:lppet/components/MyButton.dart';
import 'package:lppet/components/MyInputField.dart';
import 'package:lppet/constants.dart';
import 'package:lppet/screens/home.dart';

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

    int createAccount() {
        showModal("Cuenta creada con éxito");
        return 200;
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
                                    if (email.text == '' ||
                                        userName.text == '' ||
                                        nombre.text == '' ||
                                        apellido.text == '' ||
                                        ocupacion.text == '' ||
                                        password.text == '') {
                                      showError(
                                        "Se deben llenar todos los campos."
                                      );
                                    } else {
                                      createAccount();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Home()
                                        ),
                                      );
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
