import 'package:aiuniverstestmap/domain/use_cases/fetch_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import your repositories, use cases, and Cubits
import 'package:aiuniverstestmap/domain/use_cases/get_current_location.dart';
import 'package:aiuniverstestmap/domain/use_cases/get_place_name_use_case.dart';
import 'package:aiuniverstestmap/data/repositories/poi_repository_impl.dart';
import 'package:aiuniverstestmap/data/repositories/prediction_repository_impl.dart';
import 'package:aiuniverstestmap/domain/repositories/poi_repository.dart';
import 'package:aiuniverstestmap/domain/repositories/prediction_repository.dart';
import 'package:aiuniverstestmap/presentation/blocs/location_cubit.dart';
import 'package:aiuniverstestmap/presentation/blocs/poi_cubit.dart';
import 'package:aiuniverstestmap/presentation/blocs/prediction_cubit.dart';
import 'package:aiuniverstestmap/presentation/pages/map_page.dart';
import 'package:aiuniverstestmap/data/repositories/location_repository_impl.dart';
import 'package:aiuniverstestmap/data/data_sources/poi_data_source.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Create instances of your data sources and repositories
  final poiDataSource = POIDataSource(); // Assuming this is the required data source
  final poiRepository = POIRepositoryImpl(poiDataSource); // Provide the required argument
  final predictionRepository = PredictionRepositoryImpl();
  final locationRepository = LocationRepositoryImpl();

  final getCurrentLocation = GetCurrentLocation(locationRepository);
  final getPlaceNameUseCase = GetPlaceNameUseCase();

  runApp(MyApp(
    predictionRepository: predictionRepository,
    poiRepository: poiRepository,
    getPlaceNameUseCase: getPlaceNameUseCase,
    getCurrentLocation: getCurrentLocation,
  ));
}

// Main application widget
class MyApp extends StatelessWidget {
  final PredictionRepository predictionRepository;
  final POIRepository poiRepository;
  final GetPlaceNameUseCase getPlaceNameUseCase;
  final GetCurrentLocation getCurrentLocation;
  final fetchRoute = FetchRoute(); // Adjust as per your implementation
  final getPlaceName = GetPlaceName(); // Adjust as per your implementation

   MyApp({
    super.key,
    required this.predictionRepository,
    required this.poiRepository,
    required this.getPlaceNameUseCase,
    required this.getCurrentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide LocationCubit
        BlocProvider(
          create: (_) => LocationCubit(getCurrentLocation, fetchRoute, getPlaceName),
        ),
        // Provide POICubit
        BlocProvider(
          create: (context) => POICubit(poiRepository),
        ),
        // Provide PredictionCubit
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
