import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AnimalList extends StatefulWidget {
  @override
  _AnimalListState createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> {
  List<dynamic> animales = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAnimales();
  }

  Future<void> fetchAnimales() async {
    try {
      var response = await Dio().get('http://127.0.0.1:5000/animales');
      setState(() {
        animales = response.data['animales'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al obtener los datos';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Animales')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: animales.length,
                  itemBuilder: (context, index) {
                    var animal = animales[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(animal['nombre'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Especie: ${animal['especie']}'),
                            Text('Estado de adopción: ${animal['estado_adopcion']}'),
                            Text('Edad: ${animal['edad']} años'),
                            Text('Fecha de ingreso: ${animal['fecha_ingreso']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
