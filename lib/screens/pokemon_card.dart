import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  final String name;
  final int id;
  final String type;
  final String imageUrl;

  PokemonCard({
    required this.name,
    required this.id,
    required this.type,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.network(
            imageUrl,
            height: 300,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: $id'),
                Text('Name: $name'),
                Text('Type: $type'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
