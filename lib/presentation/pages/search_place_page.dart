import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPlacePage extends StatefulWidget {
  @override
  _SearchPlacePageState createState() => _SearchPlacePageState();
}

class _SearchPlacePageState extends State<SearchPlacePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _predictions = [];

  Future<void> _fetchPredictions(String query) async {
    final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _predictions = data;
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print('Error fetching predictions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Places'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _fetchPredictions(_searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                final description = prediction['display_name'] as String;

                return ListTile(
                  title: Text(description),
                  onTap: () {
                    Navigator.pop(context, prediction);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
