import 'package:flutter/material.dart';
import '../models/tourist_place.dart';
import 'map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  final TouristPlace place;

  const PlaceDetailScreen({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              place.imageUrl,
              width: double.infinity,
              height: 230,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 230,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.location_city_outlined, size: 56),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Address',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(place.address),
                  const SizedBox(height: 16),
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(place.history),
                  const SizedBox(height: 16),
                  Text(
                    'Culture',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(place.culture),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.map),
                      label: const Text('View on Map'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapScreen(
                              title: place.name,
                              latitude: place.latitude,
                              longitude: place.longitude,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
