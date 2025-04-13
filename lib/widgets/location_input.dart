import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationInput extends StatefulWidget {
  final void Function(PlaceLocation location) onPickedLocation;

  const LocationInput({required this.onPickedLocation, super.key});

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isSending = false;
  String? address;

  Future<void> savePlace(LatLng location) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${location.latitude}&lon=${location.longitude}',
    );

    final response = await http.get(url, headers: {'User-Agent': 'FlutterApp'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      address = data["display_name"];
    } else {
      print('Erro: ${response.statusCode}');
      return null;
    }

    _pickedLocation = PlaceLocation(
      latitude: location.latitude,
      longitude: location.longitude,
      addres: address!,
    );
    widget.onPickedLocation(_pickedLocation!);

  }

  void _getCurrentLocation() async {
    Location location = new Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isSending = true;
    });

    locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    setState(() {      
      savePlace(LatLng(lat!, lng!));
    });

    print(locationData.latitude);
    print(locationData.longitude);

    setState(() {
      _isSending = false;
    });
  }

  void selectOnMap() async {
  final selectedLocation = await Navigator.of(context).push<LatLng>(
    MaterialPageRoute(
      builder: (ctx) => MapScreen(
        location: _pickedLocation ??
            PlaceLocation(
              latitude: -18,
              longitude: -52,
              addres: "",
            ),
      ),
    ),
  );

  if (selectedLocation == null) return;

  setState(() {
    _isSending = true;
  });

  await savePlace(selectedLocation);

  setState(() {
    _isSending = false;
  });
}


  @override
  Widget build(BuildContext context) {
    Widget preview = Text(
      "No location selected",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    if (_isSending) {
      preview = CircularProgressIndicator();
    }

    if (_pickedLocation != null) {
      preview = FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
            _pickedLocation!.latitude,
            _pickedLocation!.longitude,
          ),
          initialZoom: 15.0,
          interactionOptions: InteractionOptions(flags: 0),
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
                point: LatLng(
                  _pickedLocation!.latitude,
                  _pickedLocation!.longitude,
                ),
                width: 40,
                height: 40,
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          height: 120,
          width: double.maxFinite,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: preview,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: Text("Current location"),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: selectOnMap,
              label: Text("Select location"),
              icon: Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
