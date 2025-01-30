// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
class Usuario {
  String password;
  String email;

  Usuario({
    required this.password,
    required this.email,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        password: json["contrasena"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "password": password,
        "email": email,
      };
}
