import 'package:flutter/material.dart';
import 'package:lppet/components/MyButton.dart';
import 'package:lppet/components/MyInputField.dart';
import 'package:lppet/constants.dart';
import 'package:lppet/screens/donation_aproved.dart';
import 'package:lppet/screens/donation_history.dart';
import 'package:lppet/screens/home.dart';
import 'package:dio/dio.dart';

class Donation extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController montoController = TextEditingController();

  Donation({super.key});
  
  Future<void> _makeDonation(BuildContext context) async {
    // logic of donation
    Dio dio = Dio();
    final String url = "http://127.0.0.1:5000/postDonacion";
    int _usuarioId = 1;
    String _monto = montoController.text;

    final Map<String, dynamic> donationData = {
      'usuario_id': _usuarioId,
      'monto': _monto,
    };

    try {
      Response response = await dio.post(
        url,
        data: donationData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DonationAproved()),
        );
      } else {
        // Manejar errores
        print("Error: ${response.statusMessage}");
      }
    } catch (e) {
      // Manejo de excepciones
      print("Error al realizar la donación: $e");
    }
  }

  void _seeDonations(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DonationHistory()),
    );
  }

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
            ); // Acción de cerrar
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyButton(
                label: "Historial de Donaciones",
                onTap: () => _seeDonations(context),
                buttonColor: Colors.grey,
                labelColor: Colors.white,
                cornerRadius: 10.0,
                shadowIntensity: 5.0,
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Ingresa el monto que quieres donar",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontFamily: 'LexendDeca',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: MyInputField(
                  hint: "Monto",
                  controller: montoController,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  "Datos de la Tarjeta",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontFamily: 'LexendDeca',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: textColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyInputField(
                      hint: "Titular",
                      controller: nameController,
                    ),
                    const SizedBox(height: 15),
                    MyInputField(
                      hint: "Número de Tarjeta",
                      controller: cardController,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/tarjetas.png',
                            height: 100,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: MyInputField(
                            hint: "Expiración",
                            controller: expirationController,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: MyInputField(
                            hint: "CVV",
                            controller: cvvController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              MyButton(
                label: "Donar",
                onTap: () => _makeDonation(context),
                buttonColor: Colors.grey,
                labelColor: Colors.white,
                cornerRadius: 10.0,
                shadowIntensity: 5.0,
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/gato_saludando.png',
                  height: 200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
