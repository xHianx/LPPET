import 'package:flutter/material.dart';
import 'package:lppet/components/MyButton.dart';
import 'package:lppet/components/MyInputField.dart';
import 'package:lppet/constants.dart';
// import 'package:lppet/screens/create_account.dart';
// import 'package:lppet/screens/main_window.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => MainWindow()),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Inicio de sesión exitoso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Verifica tus credenciales')),
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
                            await login(_emailController.text,
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => CreateAccount()),
                            // );
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
