import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final LatLng initialPosition;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Function(LatLng) onTap;
  final Function(GoogleMapController) onMapCreated;

  const MapWidget({
    Key? key,
    required this.initialPosition,
    required this.markers,
    required this.polylines,
    required this.onTap,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 14.0,
      ),
      markers: markers,
      polylines: polylines,
      onTap: onTap,
      onMapCreated: onMapCreated,
    );
  }
}
