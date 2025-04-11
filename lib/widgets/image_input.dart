import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {

  const ImageInput({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _image;

  void _takePicture() async {
    final imagePicker =ImagePicker();
    final selectedImage = await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (selectedImage == null) {
      return;
    }

    setState(() {
      _image = File(selectedImage.path);  
    });

  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(onPressed: _takePicture, label: Text("Take picture"), icon: Icon(Icons.camera),);

    if (_image != null) {
      content = GestureDetector(
        onTap: () => _takePicture(),
        child: Image.file(_image!, fit: BoxFit.cover, width: double.maxFinite,) ,
      );
    }

    return Container(
      height: 250,
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary)
      ),
      child: content
    );
  }
}