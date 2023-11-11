import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'pokemon_card.dart';
import 'pokemon_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Map<String, dynamic>>> pokemonList;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pokemonList = fetchPokemonList();
  }

  Future<List<Map<String, dynamic>>> fetchPokemonList() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['results'];
      final List<Map<String, dynamic>> pokemonList = [];

      for (final pokemon in data) {
        final pokemonDetailResponse =
            await http.get(Uri.parse(pokemon['url'].toString()));

        if (pokemonDetailResponse.statusCode == 200) {
          final Map<String, dynamic> pokemonDetail =
              jsonDecode(pokemonDetailResponse.body);
          pokemonList.add(pokemonDetail);
        } else {
          throw Exception('Failed to load Pokémon details');
        }
      }

      return pokemonList;
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }

  void nextPokemon() {
    if (currentIndex < 19) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void previousPokemon() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void showDetails() async {
    final List<Map<String, dynamic>>? fetchedPokemonList = await pokemonList;

    if (fetchedPokemonList != null) {
      final currentPokemon = fetchedPokemonList[currentIndex];
      // print(currentIndex);
      // print(currentPokemon);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PokemonDetailsScreen(
            name: currentPokemon['name'],
            id: currentIndex + 1,
            type: currentPokemon['types'][0]['type']['name'],
            imageUrl: currentPokemon['sprites']['front_default'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed:() {
              Navigator.pushNamed(context, 'settings');
            }
          ),
        ],
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: pokemonList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Map<String, dynamic>> pokemonData = snapshot.data!;
            final currentPokemon = pokemonData[currentIndex];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PokemonCard(
                  name: currentPokemon['name'],
                  id: currentPokemon['id'],
                  type: currentPokemon['types'][0]['type']['name'],
                  imageUrl: currentPokemon['sprites']['front_default'],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: previousPokemon,
                      child: Text('Previous'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red)
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: showDetails,
                      child: Text('Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red)
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: nextPokemon,
                      child: Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red)
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
