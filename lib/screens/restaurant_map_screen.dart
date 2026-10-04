import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/restaurant.dart';

class RestaurantMapScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantMapScreen({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final location = LatLng(
      restaurant.latitude,
      restaurant.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: MarkerId(restaurant.id),
            position: location,
            infoWindow: InfoWindow(
              title: restaurant.name,
              snippet: restaurant.address,
            ),
          ),
        },
        zoomControlsEnabled: true,
        myLocationButtonEnabled: false,
      ),
    );
  }
}