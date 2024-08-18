import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aiuniverstestmap/presentation/blocs/location_cubit.dart';
import 'package:aiuniverstestmap/presentation/blocs/poi_cubit.dart';
import 'package:aiuniverstestmap/presentation/blocs/prediction_cubit.dart';
import 'package:aiuniverstestmap/domain/entities/poi.dart';
import 'package:http/http.dart' as http;
import '../blocs/poi_state.dart';
import '../blocs/prediction_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _departController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  LatLng? tappedLocation;
  LatLng? currentLocation;
  bool _showForm = false;
  bool _isLoading = false;
  final Set<Marker> _markers = {};
  final List<LatLng> _routePoints = [];
  GoogleMapController? _mapController;
  List<Map<String, dynamic>> _suggestions = [];
  String? _selectedDepartureLocation;
  String _tripDuration = '';
  @override
  void initState() {
    super.initState();
    _setCurrentLocationMarker();

    final predictionCubit = context.read<PredictionCubit>();

    predictionCubit.stream.listen((state) async {
      if (state is PredictionLoaded) {
        setState(() {
          _suggestions = state.predictions;
        });
      } else if (state is PredictionError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    });
  }

  Future<String?> getPlaceName(double latitude, double longitude) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching place name: $e');
      return null;
    }
  }

  Future<void> _handleDepartureSearch(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      final locationCubit = context.read<LocationCubit>();
      final loc = await locationCubit.getCurrentLocation();

      await context.read<PredictionCubit>().fetchPredictions(
        query: query,
        latitude: loc.latitude,
        longitude: loc.longitude,
      );

      setState(() {
        _isLoading = false;
      });
    } else {
      if (currentLocation != null) {
        final placeName = await getPlaceName(
          currentLocation!.latitude,
          currentLocation!.longitude,
        );
        setState(() {
          _departController.text = placeName ?? 'Current Location';
          _selectedDepartureLocation = placeName ?? 'Current Location';
        });
      }
    }
  }

  Future<void> _handleDestinationSearch(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      final locationCubit = context.read<LocationCubit>();
      final loc = await locationCubit.getCurrentLocation();

      await context.read<PredictionCubit>().fetchPredictions(
        query: query,
        latitude: loc.latitude,
        longitude: loc.longitude,
      );

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _suggestions.clear();
      });
    }
  }

  Future<void> _setCurrentLocationMarker() async {
    final locationCubit = context.read<LocationCubit>();
    await locationCubit.fetchCurrentLocation();
    final loc = await locationCubit.getCurrentLocation();
    final placeName = await getPlaceName(loc.latitude, loc.longitude);
    setState(() {
      currentLocation = LatLng(loc.latitude, loc.longitude);
      _departController.text = placeName ?? 'Current Location';
      _selectedDepartureLocation = placeName ?? 'Current Location';
      _updateMarkersAndRoute();
    });

    if (currentLocation != null && _mapController != null) {
      _zoomToLocation(currentLocation!);
    }
  }

  Future<Map<String, dynamic>> fetchRoute(LatLng start, LatLng end) async {
    final url = 'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'] as List;
      final duration = data['routes'][0]['duration']; // Duration in seconds

      final points = route.map((point) => LatLng(point[1], point[0])).toList();

      return {
        'points': points,
        'duration': duration, // Duration in seconds
      };
    } else {
      throw Exception('Failed to load route');
    }
  }

  Future<void> _updateMarkersAndRoute() async {
    if (currentLocation != null && tappedLocation != null) {
      try {

        final routeData = await fetchRoute(currentLocation!, tappedLocation!);
        final routePoints = routeData['points'] as List<LatLng>;
        final durationSeconds = routeData['duration'] as double;

        // Convert duration to a readable format
        final durationMinutes = (durationSeconds / 60).round();

        // Fetch place names for current and tapped locations
        final currentLocationName = await getPlaceName(
          currentLocation!.latitude,
          currentLocation!.longitude,
        ) ?? 'Current Location';

        final tappedLocationName = await getPlaceName(
          tappedLocation!.latitude,
          tappedLocation!.longitude,
        ) ?? 'Searched Location';

        setState(() {
          _routePoints
            ..clear()
            ..addAll(routePoints);
          _tripDuration = '$durationMinutes minutes';
          _markers
            ..clear()
            ..add(
              Marker(
                markerId: const MarkerId('current_location'),
                position: currentLocation!,
                infoWindow: InfoWindow(
                  title: currentLocationName,
                  snippet: 'Starting point',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
            )..add(
            Marker(
              markerId: const MarkerId('tapped_location'),
              position: tappedLocation!,
              infoWindow: InfoWindow(
                title: tappedLocationName,
                snippet: 'Estimated Duration: $durationMinutes minutes',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          );
        });

        // Optionally, display the duration in a UI element
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trip Duration: $durationMinutes minutes')),
        );
      } catch (e) {
        print('Error fetching route: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching route: $e')),
        );
      }
    }
  }



  void _zoomToLocation(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 15.0),
    );
  }

  Set<Marker> _createMarkersFromPOIs(List<POI> poiList) {
    return poiList.map((poi) {
      return Marker(
        markerId: MarkerId(poi.id),
        position: LatLng(poi.latitude, poi.longitude),
        infoWindow: InfoWindow(title: poi.name),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              if (_showForm)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSearchField(
                        controller: _departController,
                        label: 'Where from?',
                        icon: Icons.my_location,
                        onChanged: _handleDepartureSearch,
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      _buildSearchField(
                        controller: _destinationController,
                        label: 'Where to?',
                        icon: Icons.location_pin,
                        onChanged: _handleDestinationSearch,
                        onTap: () {},
                      ),
                      if (_suggestions.isNotEmpty)
                        _buildSuggestionsList(),
                    ],
                  ),
                ),
              Text('Trip Duration: $_tripDuration'),
              Expanded(

                child: BlocBuilder<LocationCubit, LocationState>(
                  builder: (context, state) {
                    if (state is LocationInitial || _isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LocationLoaded) {
                      final position = state.location;
                      return BlocBuilder<POICubit, POIState>(
                        builder: (context, poiState) {
                          if (poiState is POILoaded) {
                            List<POI> poiList = poiState.poiList;

                            Set<Marker> markers = _createMarkersFromPOIs(poiList);
                            markers.addAll(_markers);

                            Set<Polyline> polylines = {
                              Polyline(
                                polylineId: const PolylineId('route1'),
                                points: _routePoints,
                                color: Colors.blue,
                                width: 5,
                              ),
                            };

                            return GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(position.latitude, position.longitude),
                                zoom: 15.0,
                              ),
                              markers: markers,
                              polylines: polylines,
                              onMapCreated: (GoogleMapController controller) {
                                _mapController = controller;
                                _zoomToLocation(position as LatLng);
                              },
                              onTap: (LatLng location) async {
                                final placeName = await getPlaceName(location.latitude, location.longitude);
                                setState(() {
                                  tappedLocation = location;
                                  _destinationController.text = placeName ?? '${location.latitude}, ${location.longitude}';
                                  _updateMarkersAndRoute();
                                });
                              },
                            );
                          } else if (poiState is POILoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else {
                            return const Center(child: Text('Failed to load POIs'));
                          }
                        },
                      );
                    } else if (state is LocationError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else {
                      return const Center(child:  CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                _setCurrentLocationMarker();
              },
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showForm = !_showForm;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Set Your Destination?",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required void Function(String) onChanged,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      onTap: onTap,
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        final displayName = suggestion['display_name'] ?? 'No name available';
        final latString = suggestion['lat'] ?? '0';
        final lonString = suggestion['lon'] ?? '0';

        // Convert latitude and longitude from String to double
        final latitude = double.tryParse(latString) ?? 0.0;
        final longitude = double.tryParse(lonString) ?? 0.0;

        return ListTile(
          title: Text(displayName),
          onTap: () async {
            // Update tappedLocation
            tappedLocation = LatLng(latitude, longitude);
            _destinationController.text = displayName;

            // Fetch route and update map
            await _updateMarkersAndRoute();

            // Optionally clear suggestions
            setState(() {
              _suggestions.clear();
            });
          },
        );
      },
    );
  }

}
