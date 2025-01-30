import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Si deseas precargar los datos del usuario, puedes hacer una solicitud GET aquí.
  }

  Future<void> updateProfile() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await Dio().put(
        'http://127.0.0.1:5000/actualizarUsuario', // Reemplazar con la URL real
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado')),
        );
      } else {
        setState(() {
          errorMessage = 'Error al actualizar perfil';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al conectar con el servidor';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration:
                        const InputDecoration(labelText: "Correo electrónico"),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Contraseña"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateProfile,
                    child: const Text("Actualizar Perfil"),
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
