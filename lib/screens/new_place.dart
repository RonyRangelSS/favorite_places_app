import 'dart:io';

import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/providers/places_provider.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:favorite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlace extends ConsumerStatefulWidget {

  const NewPlace({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewPlaceState();
  }
}

class _NewPlaceState extends ConsumerState<NewPlace> {
    final _formKey = GlobalKey<FormState>();
    String _enteredTitle = "";
    File? _selectedImage;
    PlaceLocation? _pickedLocation;


    void addPlace() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        if (_selectedImage == null) {
          return;
        }

        if (_pickedLocation == null) {
          return;
        }

        setState(() {
          ref.read(placesProvider.notifier).addPlace(_enteredTitle, _selectedImage!, _pickedLocation!);
        });
      Navigator.of(context).pop();
      }


    }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text("Add new Place"),),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  label: Text("Title"),
                ),
                onSaved: (newValue) {
                  _enteredTitle = newValue!;
                },
                validator: (value) {
                  if (value == null || value.trim().length > 50 || value.trim().length <= 1) {
                    return "Must be between 1 and 50 characters";
                  }
          
                  return null;
                },
              ),
              ImageInput(onPickImage: (image) {
                _selectedImage = image;
              },),
              SizedBox(
                height: 10,
              ),
              LocationInput(onPickedLocation: (location) {
                _pickedLocation = location;
              },),
              SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(onPressed: addPlace, icon: Icon(Icons.add), label: Text("Add place")),
            ],
          ),
        )),
    );
  }
}