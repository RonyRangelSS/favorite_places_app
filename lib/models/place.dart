import 'package:uuid/uuid.dart';
import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String addres;

  const PlaceLocation({required this.latitude, required this.longitude, required this.addres});
}

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place({required this.title, required this.image, required this.location}) : id = Uuid().v4();
}