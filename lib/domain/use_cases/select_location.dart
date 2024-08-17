import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationUseCase {
  LatLng? tappedLocation;

  void selectFromMap(LatLng location) {
    tappedLocation = location;
  }

  LatLng? getSelectedLocation() {
    return tappedLocation;
  }
}
