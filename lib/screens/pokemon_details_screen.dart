import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonDetailsScreen extends StatefulWidget {
  final String name;
  final int id;
  final String type;
  final String imageUrl;

  PokemonDetailsScreen({
    required this.name,
    required this.id,
    required this.type,
    required this.imageUrl,
  });

  @override
  _PokemonDetailsScreenState createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  late Future<Map<String, dynamic>> pokemonDetails;

  @override
  void initState() {
    super.initState();
    pokemonDetails = fetchPokemonDetails(widget.id);
  }

  Future<Map<String, dynamic>> fetchPokemonDetails(int pokemonId) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      final speciesUrl = data['species']['url'];
      final speciesResponse = await http.get(Uri.parse(speciesUrl));
      final speciesData = jsonDecode(speciesResponse.body);

      final evolutionChainUrl = speciesData['evolution_chain']['url'];
      final evolutionChainResponse = await http.get(Uri.parse(evolutionChainUrl));
      final evolutionChainData = jsonDecode(evolutionChainResponse.body);

      data['evolution_chain'] = evolutionChainData;
      
      return data;
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }


  List<String> extractEvolutionChain(Map<String, dynamic> evolutionData) {
    final List<String> evolutions = [];

    evolutions.add(evolutionData['species']['name']);

    if (evolutionData['evolves_to'] != null && evolutionData['evolves_to'].isNotEmpty) {
      for (final evolvedForm in evolutionData['evolves_to']) {
        final evolvedSpeciesName = evolvedForm['species']['name'];
        evolutions.add(evolvedSpeciesName);
        evolutions.addAll(extractEvolutionChain(evolvedForm));
      }
    }

    return evolutions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon Details'),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: pokemonDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final Map<String, dynamic> details = snapshot.data!;
            final List<String> evolutions = extractEvolutionChain(details['evolution_chain']['chain']);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column( 
                        children: [
                          Image.network(
                            widget.imageUrl,
                            height: 200.0,
                            width: 200.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'ID: ${widget.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Name: ${widget.name}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Type: ${widget.type}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Height: ${details['height']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Weight: ${details['weight']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Evolution Chain:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (evolutions.isNotEmpty)
                      Container(
                        height: 50.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: evolutions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    evolutions[index],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      const Text('No evolutions'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
