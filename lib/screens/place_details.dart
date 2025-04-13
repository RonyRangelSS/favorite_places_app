import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final Place place;

  const PlaceDetailsScreen({required this.place, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.maxFinite,
            height: double.maxFinite,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(place.location.latitude, place.location.longitude),
                              initialZoom: 15.0,
                              onTap: (tapPosition, point) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MapScreen(location: place.location, isSelecting: false,)));
                              },
                        
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c'],
                                userAgentPackageName: "com.favoriteplaces",
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(place.location.latitude, place.location.longitude),
                                    width: 40,
                                    height: 40,
                                    child: Icon(Icons.location_on, color: Colors.red, size: 40),
                                  ),
                                ],
                              ),
                            ]
                          ),
                        ),
                Text(
                  place.location.addres,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
