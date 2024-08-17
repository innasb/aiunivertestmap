import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aiuniverstestmap/presentation/blocs/location_cubit.dart';
import 'package:aiuniverstestmap/presentation/blocs/poi_cubit.dart';
import 'package:aiuniverstestmap/presentation/blocs/prediction_cubit.dart';
import 'package:aiuniverstestmap/domain/entities/poi.dart';
import 'package:uuid/uuid.dart';
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
  late String _sessionToken;
  final Set<Marker> _markers = {};
  final List<LatLng> _routePoints = [];
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _sessionToken = const Uuid().v4();
    _setCurrentLocationMarker();
    final predictionCubit = context.read<PredictionCubit>();

    predictionCubit.stream.listen((state) async {
      if (state is PredictionLoaded) {
        if (state.predictions.isNotEmpty) {
          final prediction = state.predictions.first;
          try {
            final latitude = prediction['lat'] as String;
            final longitude = prediction['lon'] as String;

            final placeName = await getPlaceName(double.parse(latitude), double.parse(longitude));
            if (placeName != null) {
              setState(() {
                tappedLocation = LatLng(double.parse(latitude), double.parse(longitude));
                _destinationController.text = placeName;
                _updateMarkersAndRoute();
              });
            }
          } catch (e) {
            print('Error fetching place details: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error fetching place details: $e')),
            );
          }
        }
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
        return null; // Indicate an error occurred
      }
    } catch (e) {
      print('Error fetching place name: $e');
      return null; // Indicate an error occurred
    }
  }

  Future<void> _handlePressButton(TextEditingController controller) async {
    final query = controller.text;
    final locationCubit = context.read<LocationCubit>();
    final loc = await locationCubit.getCurrentLocation();

    if (query.isNotEmpty && loc != null) {
      context.read<PredictionCubit>().fetchPredictions(
        query: query,
        latitude: loc.latitude,
        longitude: loc.longitude,
      );
    }
  }

  Future<void> _setCurrentLocationMarker() async {
    final locationCubit = context.read<LocationCubit>();
    await locationCubit.fetchCurrentLocation();
    final loc = await locationCubit.getCurrentLocation();
    if (loc != null) {
      final placeName = await getPlaceName(loc.latitude, loc.longitude);
      setState(() {
        currentLocation = LatLng(loc.latitude, loc.longitude); // Convert Position to LatLng
        _departController.text = placeName ?? 'Current Location';
        _updateMarkersAndRoute();
      });

      // Ensure markers are updated before zooming
      if (currentLocation != null && _mapController != null) {
        _zoomToLocation(currentLocation!);
      }
    }
  }

  Future<List<LatLng>> fetchRoute(LatLng start, LatLng end) async {
    final url = 'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'] as List;

      // Convert the coordinates to LatLng
      return route.map((point) => LatLng(point[1], point[0])).toList();
    } else {
      throw Exception('Failed to load route');
    }
  }

  Future<void> _updateMarkersAndRoute() async {
    if (currentLocation != null && tappedLocation != null) {
      try {
        final routePoints = await fetchRoute(currentLocation!, tappedLocation!);
        setState(() {
          _routePoints
            ..clear()
            ..addAll(routePoints);

          _markers
            ..clear()
            ..add(
              Marker(
                markerId: MarkerId('current_location'),
                position: currentLocation!,
                infoWindow: InfoWindow(title: 'Current Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
            )
            ..add(
              Marker(
                markerId: MarkerId('tapped_location'),
                position: tappedLocation!,
                infoWindow: InfoWindow(title: 'Searched Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            );
        });
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
      CameraUpdate.newLatLngZoom(location, 15.0), // Adjust zoom level as needed
    );
  }

  Set<Marker> _createMarkersFromPOIs(List<POI> pois) {
    return pois.map((poi) {
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
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      _buildSearchField(
                        controller: _destinationController,
                        label: 'Where to?',
                        icon: Icons.location_pin,
                        onTap: () => _handlePressButton(_destinationController),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: BlocBuilder<LocationCubit, LocationState>(
                  builder: (context, state) {
                    if (state is LocationInitial) {
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
                                polylineId: PolylineId('route1'),
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
                                // Optionally zoom to the initial position
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
                      return const Center(child: Text('Unknown state'));
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
              onPressed: _setCurrentLocationMarker,
              backgroundColor: Colors.black,
              child: const Icon(Icons.my_location, color: Colors.white),
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
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Where\'s Your Destination?',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
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
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      onTap: onTap,
    );
  }
}
