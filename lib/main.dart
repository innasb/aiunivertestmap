import 'package:aiuniverstestmap/domain/use_cases/get_current_location.dart';
import 'package:aiuniverstestmap/domain/use_cases/get_place_name_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aiuniverstestmap/data/repositories/poi_repository_impl.dart';
import 'package:aiuniverstestmap/data/repositories/prediction_repository_impl.dart';
import 'package:aiuniverstestmap/domain/repositories/poi_repository.dart';
import 'package:aiuniverstestmap/domain/repositories/prediction_repository.dart';
import 'package:aiuniverstestmap/presentation/blocs/location_cubit.dart';
import 'package:aiuniverstestmap/presentation/blocs/poi_cubit.dart';
import 'package:aiuniverstestmap/presentation/blocs/prediction_cubit.dart';
import 'package:aiuniverstestmap/presentation/pages/map_page.dart';

import 'data/repositories/location_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final poiRepository = POIRepositoryImpl();
  final predictionRepository = PredictionRepositoryImpl();
  final locationRepository = LocationRepositoryImpl(); // Create an instance of LocationRepositoryImpl

  final getCurrentLocation = GetCurrentLocation(locationRepository); // Create an instance of GetCurrentLocation
  final getPlaceNameUseCase = GetPlaceNameUseCase();

  runApp(MyApp(
    predictionRepository: predictionRepository,
    poiRepository: poiRepository,
    getPlaceNameUseCase: getPlaceNameUseCase,
    getCurrentLocation: getCurrentLocation, // Pass the instance here
  ));
}

class MyApp extends StatelessWidget {
  final PredictionRepository predictionRepository;
  final POIRepository poiRepository;
  final GetPlaceNameUseCase getPlaceNameUseCase;
  final GetCurrentLocation getCurrentLocation; // Add this field

  const MyApp({
    super.key,
    required this.predictionRepository,
    required this.poiRepository,
    required this.getPlaceNameUseCase,
    required this.getCurrentLocation, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocationCubit(getCurrentLocation), // Pass the instance here
        ),
        BlocProvider(
          create: (context) => POICubit(poiRepository),
        ),
        BlocProvider(
          create: (context) => PredictionCubit(predictionRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Map Explorer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MapPage(),
      ),
    );
  }
}
