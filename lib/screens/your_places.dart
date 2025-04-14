import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/providers/places_provider.dart';
import 'package:favorite_places_app/widgets/places_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places_app/screens/new_place.dart';
import 'package:flutter/material.dart';

class YourPlacesScreen extends ConsumerStatefulWidget {
  const YourPlacesScreen({super.key});

  @override
  ConsumerState<YourPlacesScreen> createState() {
    return _YourPlacesScreenState();
  }
}

class _YourPlacesScreenState extends ConsumerState<YourPlacesScreen> {
  late Future<void> _placesList;

  @override
  void initState() {
    super.initState();
    _placesList = ref.read(placesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final List<Place> placesList = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your places"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => NewPlace()));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _placesList,
        builder:
            (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : PlacesList(places: placesList),
      ),
    );
  }
}
