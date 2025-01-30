class Usuario {
  int id;
  String password;
  String email;

  Usuario({
    required this.id,
    required this.password,
    required this.email,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        password: json["contrasena"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "password": password,
        "email": email,
      };
}
