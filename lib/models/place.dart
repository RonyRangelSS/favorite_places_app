import 'package:uuid/uuid.dart';

class Place {
  final String id;
  final String title;

  Place({required this.title}) : id = Uuid().v4();
}