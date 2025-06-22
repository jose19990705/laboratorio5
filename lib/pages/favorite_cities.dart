import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

import '../Boxes.dart';
import '../models/local_cities.dart';

class FavoriteCitiesPage extends StatefulWidget {
  const FavoriteCitiesPage({super.key});

  @override
  State<FavoriteCitiesPage> createState() => _FavoriteCitiesPageState();
}

class _FavoriteCitiesPageState extends State<FavoriteCitiesPage> {
  String ciudad = '';
  double temperatura = 0.0;
  String descripcion = '';
  bool cargando = false;

  Future<void> obtenerClima(String nombreCiudad) async {
    setState(() {
      cargando = true;
    });

    final apiKey = '6e1bfc7d12091288ea27425e06f722cd';
    final url = Uri.parse(
        'http://api.weatherstack.com/current?access_key=$apiKey&query=$nombreCiudad');

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener el clima')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ciudades favoritas")),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Box<LocalCity>>(
              valueListenable: Boxes.getHiveLocalCityBox().listenable(),
              builder: (context, box, _) {
                final cities = box.values.toList().cast<LocalCity>();
                return ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return ListTile(
                      title: Text(city.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => city.delete(),
                      ),
                      onTap: () {
                        obtenerClima(city.name);
                      },
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          cargando
              ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          )
              : ciudad.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Selecciona una ciudad para ver el clima",
              style: TextStyle(fontSize: 16),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ciudad: $ciudad",
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text("Temperatura: $temperatura°C",
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text("Descripción: $descripcion",
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
