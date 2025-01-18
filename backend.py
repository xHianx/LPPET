from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
from pymongo import MongoClient
from datetime import datetime
import re
from pyfcm import FCMNotification

app = Flask(__name__)
CORS(app)

fcm = FCMNotification("rGdRoOXAB2s_uGdfEjzZg65Y1FcjCU9eC-ws16EQK8E", project_id="lppet-91af5")

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

def obtener_conexion_mongo():
    client = MongoClient("mongodb://localhost:27017/")
    return client["petmatch"]

@app.route('/crearFundacion', methods=['POST'])
def crear_fundacion():
    db_mongo = obtener_conexion_mongo()
    data = request.json
    try:
        nueva_fundacion = {
            "nombre": data.get("nombre"),
            "ubicacion": data.get("ubicacion"),
            "descripcion": data.get("descripcion"),
            "contacto": data.get("contacto"),
            "fecha_creacion": datetime.now()
        }
        db_mongo.fundaciones.insert_one(nueva_fundacion)
        return jsonify({"msg": "Fundación registrada exitosamente"}), 201
    except Exception as e:
        return jsonify({"msg": "Error al registrar fundación", "error": str(e)}), 500
    

@app.route('/fundaciones', methods=['GET'])
def listar_fundaciones():
    db_mongo = obtener_conexion_mongo()
    try:
        fundaciones = list(db_mongo.fundaciones.find({}, {"_id": 0})) 
        return jsonify({"fundaciones": fundaciones}), 200
    except Exception as e:
        return jsonify({"msg": "Error al obtener fundaciones", "error": str(e)}), 500
@app.route('/actualizarFundacion/<string:nombre>', methods=['PUT'])
def actualizar_fundacion(nombre):
    db_mongo = obtener_conexion_mongo()
    data = request.json
    try:
        actualizacion = {
            "ubicacion": data.get("ubicacion"),
            "descripcion": data.get("descripcion"),
            "contacto": data.get("contacto")
        }
        db_mongo.fundaciones.update_one({"nombre": nombre}, {"$set": actualizacion})
        return jsonify({"msg": "Fundación actualizada exitosamente"}), 200
    except Exception as e:
        return jsonify({"msg": "Error al actualizar fundación", "error": str(e)}), 500

@app.route('/eliminarFundacion/<string:nombre>', methods=['DELETE'])
def eliminar_fundacion(nombre):
    db_mongo = obtener_conexion_mongo()
    try:
        db_mongo.fundaciones.delete_one({"nombre": nombre})
        return jsonify({"msg": "Fundación eliminada exitosamente"}), 200
    except Exception as e:
        return jsonify({"msg": "Error al eliminar fundación", "error": str(e)}), 500


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

@app.route('/nuevoUsuario', methods=['POST'])
def nuevo_usuario():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not email or not re.match(r"[^@]+@[^@]+\\.[^@]+", email):
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
        
        result = fcm.notify_single_device(
            registration_id=token,
            message_title=titulo,
            message_body=mensaje
        )
        return jsonify({"msg": "Notificación enviada", "result": result}), 200
    except Exception as e:
        return jsonify({"msg": "Error al enviar notificación", "error": str(e)}), 500


if __name__ == '__main__':
    app = Flask(__name__)
    CORS(app)
    app.run(host='0.0.0.0', port=5000, debug=True)
