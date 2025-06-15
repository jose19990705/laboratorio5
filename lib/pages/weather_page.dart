import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String Fondo = 'assets/images/FS.jpg';
  String ciudad = '';
  double temperatura = 0.0;
  String descripcion = '';
  bool cargando = false;
  Future<void> obtenerClima(String nombreCiudad) async {
    setState(() {
      cargando = true;
    });

    final apiKey = '6e1bfc7d12091288ea27425e06f722cd'; // reemplaza con tu key de Weatherstack
    final url = Uri.parse('http://api.weatherstack.com/current?access_key=$apiKey&query=$nombreCiudad');

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final datos = json.decode(respuesta.body);
      setState(() {
        ciudad = datos['location']['name'];
        temperatura = datos['current']['temperature'].toDouble();
        descripcion = datos['current']['weather_descriptions'][0];
        cargando = false;
      });
    } else {
      setState(() {
        cargando = false;
      });
      throw Exception('Error al obtener el clima');
    }
  }
  @override
  void  initState(){
    super.initState();
    obtenerClima("Medellin");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(//imagen de fondo
            child: Image.asset(
              Fondo,
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, kToolbarHeight + 32, 16.0, 16.0),
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ciudad: $ciudad",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          offset: Offset(2, 2),
                          color: Colors.black87,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Temperatura: $temperatura°C",
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        shadows: [
                        Shadow(
                          blurRadius: 4,
                          offset: Offset(2, 2),
                          color: Colors.black87,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Descripción: $descripcion",
                    style: const TextStyle(fontSize: 24, color: Colors.white, shadows: [
                      Shadow(
                        blurRadius: 4,
                        offset: Offset(2, 2),
                        color: Colors.black87,
                      )
                    ],),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Buscar ciudad',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (valor) {
                      obtenerClima(valor);
                      actualizarFondo(descripcion);
                    },
                  ),
                  SizedBox(height: 400,),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
  void actualizarFondo(String descripcionClima) {
    descripcionClima = descripcionClima.toLowerCase();
    String nuevaImagen;

    if (descripcionClima.contains('sunny') || descripcionClima.contains('clear')) {
      nuevaImagen = 'assets/images/S.png';
    } else if (descripcionClima.contains('rain') || descripcionClima.contains('shower')|| descripcionClima.contains('drizzle')) {
      nuevaImagen = 'assets/images/L.png';
    } else if (descripcionClima.contains('cloud') || descripcionClima.contains('overcast')|| descripcionClima.contains('cloudy')) {
      nuevaImagen = 'assets/images/N.png';
    } else if (descripcionClima.contains('snow')|| descripcionClima.contains('sleet')) {
      nuevaImagen = 'assets/images/NI.png';
    } else if (descripcionClima.contains('thunderstorm')|| descripcionClima.contains('storm')) {
      nuevaImagen = 'assets/images/T.png';
    } else if (descripcionClima.contains('mist') || descripcionClima.contains('fog') || descripcionClima.contains('haze')) {
      nuevaImagen = 'assets/images/NIE.png';
    } else {
      nuevaImagen = 'assets/images/FS.jpg';
    }

    // Actualiza el estado con la nueva imagen
    setState(() {
      Fondo= nuevaImagen;
    });

  }
}
