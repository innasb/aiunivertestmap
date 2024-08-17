import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aiuniverstestmap/domain/entities/poi.dart';
import 'package:aiuniverstestmap/presentation/blocs/poi_cubit.dart';
import 'package:geolocator/geolocator.dart';

class AddPOIPage extends StatelessWidget {
  final Position position;

  const AddPOIPage({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add POI'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final poiCubit = context.read<POICubit>();
            final poi = POI(
              id: DateTime.now().toString(),
              name: 'New POI',
              latitude: position.latitude,
              longitude: position.longitude,
            );
            poiCubit.addPOI(poi);
          },
          child: const Text('Add POI'),
        ),
      ),
    );
  }
}
