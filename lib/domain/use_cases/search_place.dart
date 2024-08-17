// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_maps_webservices/places.dart';

class SearchLocationUseCase {
  final GoogleMapsPlaces _places;

  SearchLocationUseCase(this._places);

  Future<LatLng?> searchLocation(String apiKey, String query) async {
    final response = await _places.searchByText(query);

    if (response.isOkay && response.results.isNotEmpty) {
      final result = response.results.first;
      return LatLng(result.geometry!.location.lat, result.geometry!.location.lng);
    }

    return null;
  }
}
