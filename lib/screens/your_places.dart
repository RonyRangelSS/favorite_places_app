import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/providers/places_provider.dart';
import 'package:favorite_places_app/widgets/places_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places_app/screens/new_place.dart';
import 'package:flutter/material.dart';

class YourPlacesScreen extends ConsumerWidget {
  const YourPlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final List<Place> placesList = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your places"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewPlace()));
            }, 
            icon: Icon(Icons.add)),
        ], 
      ),
      body: PlacesList(places: placesList),
    );
  }

}

