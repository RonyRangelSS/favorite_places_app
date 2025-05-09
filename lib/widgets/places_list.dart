import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/screens/place_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  final List<Place> places;

  const PlacesList({required this.places ,super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
    child: Text("No items added yet.", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface
      ),),
  );

  if (places.isNotEmpty) {
    content = ListView
    .builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              leading: CircleAvatar(
                backgroundImage: FileImage(places[index].image),
              ) ,
              title: Text(places[index].title, style: Theme.of(context).textTheme.titleMedium,),
              subtitle: Text(places[index].location.addres, style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface
              ),),
              onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaceDetailsScreen(place: places[index]) ));
            },),
        );
      });
    }

    return content;
  }
}