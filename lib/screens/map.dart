import 'package:favorite_places_app/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation location;
  final bool isSelecting;

  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: -18,
      longitude: -52,
      addres: "",
    ),
    this.isSelecting = true
  });

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? "Pick your location" : "Your location"),
        actions: [
          if (widget.isSelecting)
            IconButton(onPressed: () {
              Navigator.of(context).pop<LatLng>(_pickedLocation);
            }, icon: Icon(Icons.save))
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(widget.location.latitude, widget.location.longitude),
          initialZoom: 3.0,
          onTap: (tapPosition, point) {
            setState(() {
              _pickedLocation = point;
            });
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
            if (_pickedLocation != null || !widget.isSelecting)
              Marker(
                key: ValueKey("m1"),
                point: _pickedLocation ??
                    LatLng(widget.location.latitude, widget.location.longitude),
                width: 40,
                height: 40,
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ]
      ),
    );
  }
}
