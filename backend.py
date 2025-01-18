import re

@app.route('/inicio', methods=['GET'])
def inicio():
    db = obtener_conexion()
    try:
        with db.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT * FROM categorias_populares")
            categorias = cursor.fetchall()

            cursor.execute("SELECT mensaje FROM mensajes_inicio")
            mensajes = cursor.fetchall()

        return jsonify({"categorias": categorias, "mensajes": mensajes}), 200
    except Exception as e:
        return jsonify({"msg": "No se pudieron obtener los datos de inicio", "error": str(e)}), 500
    finally:
        db.close()

@app.route('/animales', methods=['GET'])
def animales():
    db = obtener_conexion()
    especie = request.args.get('especie')
    ordenar_por_fecha = request.args.get('ordenar', default=False, type=bool)

    try:
        with db.cursor(dictionary=True) as cursor:
            query = "SELECT * FROM Animal WHERE 1=1"
            params = []
            if especie:
                query += " AND especie = %s"
                params.append(especie)
            if ordenar_por_fecha:
                query += " ORDER BY fecha_ingreso DESC"

            cursor.execute(query, params)
            animales = cursor.fetchall()

        return jsonify({"animales": animales}), 200
    except Exception as e:
        return jsonify({"msg": "Error al obtener animales", "error": str(e)}), 500
    finally:
        db.close()

@app.route('/nuevoUsuario', methods=['POST'])
def nuevo_usuario():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not email or not re.match(r"[^@]+@[^@]+\.[^@]+", email):
        return jsonify({"msg": "Formato de email inválido"}), 400
    if not password or len(password) < 8:
        return jsonify({"msg": "La contraseña debe tener al menos 8 caracteres"}), 400

    db = obtener_conexion()
    try:
        with db.cursor() as cursor:
            cursor.execute("INSERT INTO Usuario (email, contrasena) VALUES (%s, %s)", (email, password))
            db.commit()

        return jsonify({"msg": "Usuario registrado con éxito"}), 201
    except Exception as e:
        return jsonify({"msg": "Error al registrar usuario", "error": str(e)}), 500
    finally:
        db.close()

def obtener_conexion():
    try:
        conexion = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="petmatch"
        )
        return conexion
    except mysql.connector.Error as err:
        print(f"Error en la conexión: {err}")
        return None

failed_attempts = {}

@app.route('/iniciarSesion', methods=['POST'])
def iniciar_sesion():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if failed_attempts.get(email, 0) >= 3:
        return jsonify({"msg": "Cuenta bloqueada temporalmente"}), 403

    db = obtener_conexion()
    try:
        with db.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT * FROM Usuario WHERE email = %s", (email,))
            usuario = cursor.fetchone()

            if usuario and usuario['contrasena'] == password:
                failed_attempts[email] = 0
                return jsonify({"msg": "Inicio de sesión exitoso", "usuario": usuario}), 200

        failed_attempts[email] = failed_attempts.get(email, 0) + 1
        return jsonify({"msg": "Credenciales inválidas"}), 401
    except Exception as e:
        return jsonify({"msg": "Error al iniciar sesión", "error": str(e)}), 500
    finally:
        db.close()

@app.route('/solicitudes', methods=['POST'])
def solicitudes():
    data = request.json
    usuario_id = data.get('usuario_id')
    animal_id = data.get('animal_id')

    db = obtener_conexion()
    try:
        with db.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Solicitudes (usuario_id, animal_id, estado) VALUES (%s, %s, %s)
            """, (usuario_id, animal_id, 'pendiente'))
            solicitud_id = cursor.lastrowid
            db.commit()

        return jsonify({"msg": "Solicitud registrada", "solicitud_id": solicitud_id}), 201
    except Exception as e:
        return jsonify({"msg": "Error al registrar solicitud", "error": str(e)}), 500
    finally:
        db.close()


@app.route('/buscar', methods=['GET'])
def buscar():
    especie = request.args.get('especie')
    estado = request.args.get('estado')
    edad_minima = request.args.get('edad_minima', type=int)

    db = obtener_conexion()
    try:
        with db.cursor(dictionary=True) as cursor:
            query = "SELECT * FROM Animal WHERE 1=1"
            params = []
            if especie:
                query += " AND especie = %s"
                params.append(especie)
            if estado:
                query += " AND estado_adopcion = %s"
                params.append(estado)
            if edad_minima:
                query += " AND edad >= %s"
                params.append(edad_minima)

            cursor.execute(query, tuple(params))
            resultados = cursor.fetchall()
        return jsonify({"resultados": resultados}), 200
    except Exception as e:
        return jsonify({"msg": "Error al buscar", "error": str(e)}), 500
    finally:
        db.close()


@app.route('/notificaciones', methods=['POST'])
def notificaciones():
    data = request.json
    user_id = data.get('user_id')
    titulo = data.get('titulo')
    mensaje = data.get('mensaje')

    db = obtener_conexion()
    try:
        with db.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Notificaciones (usuario_id, titulo, mensaje, leida)
                VALUES (%s, %s, %s, %s)
            """, (user_id, titulo, mensaje, False))
            db.commit()
        return jsonify({"msg": "Notificación enviada"}), 201
    except Exception as e:
        return jsonify({"msg": "Error al enviar notificación", "error": str(e)}), 500
    finally:
        db.close()


@app.route('/simulacionDonaciones', methods=['POST'])
def simulacion_donaciones():
    data = request.json
    monto = data.get('monto', 0)
    meses = data.get('meses', 12)

    simulaciones = []
    for i in range(1, meses + 1):
        simulaciones.append({
            "mes": i,
            "monto_acumulado": i * monto,
            "porcentaje_acumulado": (i / meses) * 100
        })

    return jsonify({"simulaciones": simulaciones}), 200


def registrar_log(tipo_evento, descripcion):
    db = obtener_conexion()
    try:
        with db.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Logs (tipo_evento, descripcion, fecha) VALUES (%s, %s, NOW())
            """, (tipo_evento, descripcion))
            db.commit()
    except Exception as e:
        print(f"Error al registrar log: {e}")
    finally:
        db.close()
