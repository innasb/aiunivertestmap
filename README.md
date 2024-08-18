
# Flutter Interactive Map Project Documentation

## Project Overview

This Flutter application provides interactive map features, real-time location tracking, and the ability to define and manage points of interest (POIs). The application uses clean architecture principles and state management with Bloc (Cubit).

## Features

- **Interactive Map**: Displays an interactive map using Google Maps.
- **Real-Time Location**: Tracks and displays the user's current location.
- **Points of Interest**: Allows users to define and manage POIs.
- **Location Selection**: Users can either select a location on the map or search for it using OpenStreetMap (OSM).
- **Route Display**: Shows routes between departure and destination points.

## Architecture

The application follows clean architecture principles, organizing the code into distinct layers:

1. **Presentation Layer**: Handles UI components and user interactions.
2. **Domain Layer**: Contains business logic and entities.
3. **Data Layer**: Manages data sources and repositories.

## State Management

The app uses Bloc (Cubit) for state management to handle various states and events efficiently.

## Project Structure

### lib/

- **data/**
    - **data_sources/**: Contains data source implementations.
        - `location_data_source.dart`: Manages location data retrieval.
        - `poi_data_source.dart`: Handles POI data operations.
        - `route_data_source.dart`: Manages route data retrieval.
    - **models/**: Defines data models.
        - `poi_model.dart`: Model for POIs.
    - **repositories/**: Implements repository interfaces.
        - `location_repository_impl.dart`: Implementation for location repository.
        - `place_repository_impl.dart`: Implementation for place repository.
        - `poi_repository_impl.dart`: Implementation for POI repository.
        - `prediction_repository_impl.dart`: Implementation for prediction repository.
        - `route_repository_impl.dart`: Implementation for route repository.

- **domain/**
    - **entities/**: Contains business entities.
        - `location.dart`: Entity representing a location.
        - `poi.dart`: Entity representing a POI.
        - `prediction.dart`: Entity representing a prediction.
        - `prediction_details.dart`: Entity for prediction details.
    - **repositories/**: Defines repository interfaces.
        - `location_repository.dart`: Interface for location repository.
        - `place_repository.dart`: Interface for place repository.
        - `poi_repository.dart`: Interface for POI repository.
        - `prediction_repository.dart`: Interface for prediction repository.
        - `route_repository.dart`: Interface for route repository.
    - **use_cases/**: Contains use case implementations.
        - `add_poi.dart`: Use case for adding a POI.
        - `fetch_and_reverse_geocode_prediction.dart`: Fetches and reverse geocodes predictions.
        - `fetch_predictions.dart`: Fetches predictions.
        - `fetch_route.dart`: Fetches route information.
        - `get_current_location.dart`: Gets the current location.
        - `get_place_name_use_case.dart`: Gets the name of a place.
        - `get_pois.dart`: Retrieves POIs.
        - `get_route.dart`: Gets route information.
        - `search_place.dart`: Searches for places.
        - `search_pois.dart`: Searches for POIs.
        - `select_location.dart`: Selects a location.

- **presentation/**
    - **blocs/**: Contains Cubit classes for state management.
        - `location_cubit.dart`: Cubit for managing location states.
        - `location_state.dart`: States for location Cubit.
        - `poi_cubit.dart`: Cubit for managing POI states.
        - `poi_state.dart`: States for POI Cubit.
        - `prediction_cubit.dart`: Cubit for managing prediction states.
        - `prediction_state.dart`: States for prediction Cubit.
        - `route_cubit.dart`: Cubit for managing route states.
        - `route_state.dart`: States for route Cubit.
    - **pages/**: Contains pages of the application.
        - `map_page.dart`: Page with interactive map and location features.
    - **widgets/**: Custom widgets used across the application.
        - `map_widget.dart`: Widget for displaying the map.

## Setup and Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/innasb/aiunivertestmap.git
   ```
2. Navigate to the project directory:
   ```bash
   cd aiunivertestmap
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

## Usage

1. Run the application:
   ```bash
   flutter run
   ```
2. Use the bottom navigation bar to access different features:
    - **Map Page**: View and interact with the map.
    - **Search**: Search for locations using OSM.

## API Integration
OpenStreetMap Integration:

- **Search API**: Used to search for locations and POIs.
- **Reverse Geocoding**: Converts coordinates into human-readable addresses.

## Google Maps Integration:

- **Interactive Map:** Displays the map and handles user interactions.


## Documentation

- **API Usage**: [OpenStreetMap API Documentation](https://wiki.openstreetmap.org/wiki/OpenStreetMap_API)
- **Google Maps API Documentation**: [Google Maps Platform Documentation](https://developers.google.com/maps/documentation)

