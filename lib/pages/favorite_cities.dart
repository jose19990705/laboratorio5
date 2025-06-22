// pages/favorite_cities_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Boxes.dart';
import '../models/local_cities.dart';

class FavoriteCitiesPage extends StatelessWidget {
  const FavoriteCitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ciudades favoritas")),
      body: ValueListenableBuilder<Box<LocalCity>>(
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
              );
            },
          );
        },
      ),
    );
  }
}

