import 'package:flutter/material.dart';
import 'package:lppet/constants.dart';
import 'package:lppet/screens/home.dart';
import 'package:dio/dio.dart';

class DonationHistory extends StatefulWidget {
  const DonationHistory({super.key});

  @override
  State<DonationHistory> createState() => _DonationHistoryState();
}

class _DonationHistoryState extends State<DonationHistory> {
  late Future<List<dynamic>> _futureDonaciones;

  @override
  void initState() {
    super.initState();
    _futureDonaciones = fetchDonaciones(usuario_loggeado!.id);
  }

  Future<List<dynamic>> fetchDonaciones(int usuarioId) async {
    try {
      final response = await Dio()
          .get('http://127.0.0.1:5000/getDonacionesUsuario/$usuarioId');

      if (response.statusCode == 200) {
        return response.data['donaciones'];
      } else {
        throw Exception("Error al obtener las donaciones");
      }
    } catch (e) {
      throw Exception("Error en la conexión: $e");
    }
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
        body: FutureBuilder<List<dynamic>>(
            future: _futureDonaciones,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text("No tienes donaciones registradas."));
              }

              final donaciones = snapshot.data!;

              return ListView.builder(
                itemCount: donaciones.length,
                itemBuilder: (context, index) {
                  final donacion = donaciones[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.monetization_on,
                          color: Colors.green),
                      title: Text("\$${donacion['monto']}"),
                      subtitle: Text("Fecha: ${donacion['fecha_donacion']}"),
                    ),
                  );
                },
              );
            }));
  }
}
