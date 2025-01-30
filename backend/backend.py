from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
from datetime import datetime
import re
from pyfcm import FCMNotification

app = Flask(__name__)
CORS(app)

fcm = FCMNotification("rGdRoOXAB2s_uGdfEjzZg65Y1FcjCU9eC-ws16EQK8E", project_id="lppet-91af5")

def obtener_conexion():
    try:
        conexion = mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="root",
            database="petmatch"
        )
        return conexion
    except mysql.connector.Error as err:
        print(f"Error en la conexión: {err}")
        return None

@app.route('/crearFundacion', methods=['POST'])
def crear_fundacion():
    db = obtener_conexion()
    data = request.json
    try:
        nueva_fundacion = (
            data.get("nombre"),
            data.get("ubicacion"),
            data.get("descripcion"),
            data.get("contacto"),
        )
        query = """
            INSERT INTO Fundaciones (nombre, ubicacion, descripcion, contacto)
            VALUES (%s, %s, %s, %s)
        """
        with db.cursor() as cursor:
            cursor.execute(query, nueva_fundacion)
            db.commit()
        return jsonify({"msg": "Fundación registrada exitosamente"}), 201
    except Exception as e:
        return jsonify({"msg": "Error al registrar fundación", "error": str(e)}), 500
    finally:
        db.close()

@app.route('/fundaciones', methods=['GET'])
def listar_fundaciones():
    db = obtener_conexion()
    try:
        query = "SELECT id, nombre, ubicacion, descripcion, contacto, fecha_creacion FROM Fundaciones"
        with db.cursor(dictionary=True) as cursor:
            cursor.execute(query)
            fundaciones = cursor.fetchall()
        return jsonify({"fundaciones": fundaciones}), 200
    except Exception as e:
        return jsonify({"msg": "Error al obtener fundaciones", "error": str(e)}), 500
    finally:
        db.close()

@app.route('/actualizarFundacion/<string:nombre>', methods=['PUT'])
def actualizar_fundacion(nombre):
    db = obtener_conexion()
    data = request.json
    try:
        actualizacion = (
            data.get("ubicacion"),
            data.get("descripcion"),
            data.get("contacto"),
            nombre,
        )
        query = """
            UPDATE Fundaciones
            SET ubicacion = %s, descripcion = %s, contacto = %s
            WHERE nombre = %s
        """
        with db.cursor() as cursor:
            cursor.execute(query, actualizacion)
            db.commit()
        return jsonify({"msg": "Fundación actualizada exitosamente"}), 200
    except Exception as e:
        return jsonify({"msg": "Error al actualizar fundación", "error": str(e)}), 500
    finally:
        db.close()

@app.route('/eliminarFundacion/<string:nombre>', methods=['DELETE'])
def eliminar_fundacion(nombre):
    db = obtener_conexion()
    try:
        query = "DELETE FROM Fundaciones WHERE nombre = %s"
        with db.cursor() as cursor:
            cursor.execute(query, (nombre,))
            db.commit()
        return jsonify({"msg": "Fundación eliminada exitosamente"}), 200
    except Exception as e:
        return jsonify({"msg": "Error al eliminar fundación", "error": str(e)}), 500
    finally:
        db.close()

@app.route('/estructura', methods=['GET'])
def estructura():
    secciones = [
        {"ruta": "/inicio", "descripcion": "Datos principales para la pantalla de inicio"},
        {"ruta": "/animales", "descripcion": "Explorar animales disponibles"},
        {"ruta": "/buscar", "descripcion": "Búsqueda avanzada de animales"},
        {"ruta": "/nuevoUsuario", "descripcion": "Registrar un nuevo usuario"},
        {"ruta": "/iniciarSesion", "descripcion": "Iniciar sesión de usuario"},
        {"ruta": "/solicitudes", "descripcion": "Registrar solicitudes de adopción"},
        {"ruta": "/notificaciones", "descripcion": "Registrar notificaciones para los usuarios"},
        {"ruta": "/simulacionDonaciones", "descripcion": "Simular donaciones mensuales"},
    ]
    return jsonify({"secciones": secciones}), 200

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

@app.route('/crearAnimal', methods=['POST'])
def crear_animal():
    try:
        data = request.json
        nombre = data.get('nombre')
        especie = data.get('especie')
        estado_adopcion = data.get('estado_adopcion')
        edad = data.get('edad')

        # Validación de los datos
        if not nombre or not especie or not estado_adopcion or not edad:
            return jsonify({"error": "Faltan datos obligatorios"}), 400

        # Conectar a la base de datos
        db = obtener_conexion()
        cursor = db.cursor()

        # Insertar el nuevo animal en la base de datos
        query = """
            INSERT INTO Animal (nombre, especie, estado_adopcion, edad)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(query, (nombre, especie, estado_adopcion, edad))
        db.commit()

        # Cerrar conexión
        cursor.close()
        db.close()

        return jsonify({"mensaje": "Animal creado correctamente"}), 201

    except Error as e:
        return jsonify({"error": f"Error en la base de datos: {str(e)}"}), 500
    except Exception as e:
        return jsonify({"error": f"Error inesperado: {str(e)}"}), 500

@app.route('/nuevoUsuario', methods=['POST'])
def nuevo_usuario():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not email or not re.match(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", email):
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

@app.route('/iniciarSesion', methods=['POST'])
def iniciar_sesion():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    db = obtener_conexion()
    try:
        with db.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT * FROM Usuario WHERE email = %s", (email,))
            usuario = cursor.fetchone()

            if usuario and usuario['contrasena'] == password:
                return jsonify({"msg": "Inicio de sesión exitoso", "usuario": usuario}), 200

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
        return jsonify({"msg": "Error en la búsqueda", "error": str(e)}), 500
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

@app.route('/postDonacion', methods=['POST'])
def post_donacion():
    try:
        db = obtener_conexion()
        data = request.json
        usuario_id = data.get('usuario_id')
        monto = data.get('monto')

        if not usuario_id or not monto:
            return jsonify({"error": "usuario_id y monto son obligatorios"}), 400

        cursor = db.cursor()

        # Insertar la donación en la base de datos
        query = "INSERT INTO Donaciones (usuario_id, monto) VALUES (%s, %s)"
        cursor.execute(query, (usuario_id, monto))
        db.commit()
        donacion_id = cursor.lastrowid  # Obtener el ID del registro insertado
        cursor.close()

        return jsonify({"mensaje": "Donación registrada exitosamente", "donacion_id": donacion_id}), 201

    except mysql.connector.Error as err:
        return jsonify({"error": f"Error en la base de datos: {str(err)}"}), 500

@app.route('/getDonaciones', methods=['GET'])
def get_donaciones():
    try:
        db = obtener_conexion()
        cursor = db.cursor(dictionary=True)  # Retorna los resultados como diccionarios

        query = "SELECT id, usuario_id, monto, fecha_donacion FROM Donaciones"
        cursor.execute(query)
        donaciones = cursor.fetchall()  # Obtener todas las donaciones

        cursor.close()
        return jsonify({"donaciones": donaciones}), 200

    except mysql.connector.Error as err:
        return jsonify({"error": f"Error en la base de datos: {str(err)}"}), 500

@app.route('/getDonacionesUsuario/<int:usuario_id>', methods=['GET'])
def get_donaciones_usuario(usuario_id):
    try:
        db = obtener_conexion()
        cursor = db.cursor(dictionary=True)  # Retorna los resultados como diccionarios

        query = "SELECT id, usuario_id, monto, fecha_donacion FROM Donaciones WHERE usuario_id = %s"
        cursor.execute(query, (usuario_id,))
        donaciones = cursor.fetchall()  # Obtener todas las donaciones del usuario

        cursor.close()
        return jsonify({"usuario_id": usuario_id, "donaciones": donaciones}), 200

    except mysql.connector.Error as err:
        return jsonify({"error": f"Error en la base de datos: {str(err)}"}), 500


@app.route('/logs', methods=['GET'])
def consultar_logs():
    db = obtener_conexion()
    try:
        with db.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT * FROM Logs")
            logs = cursor.fetchall()
        return jsonify({"logs": logs}), 200
    except Exception as e:
        return jsonify({"msg": "Error al consultar logs", "error": str(e)}), 500
    finally:
        db.close()

@app.route('/enviarPush', methods=['POST'])
def enviar_push():
    data = request.json
    token = data.get('token')  
    titulo = data.get('titulo')  
    mensaje = data.get('mensaje')  

    try:
        result = fcm.notify_single_recipient(
            registration_id=token,
            message_title=titulo,
            message_body=mensaje
        )
        return jsonify({"msg": "Notificación enviada", "result": result}), 200
    except Exception as e:
        return jsonify({"msg": "Error al enviar notificación", "error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
