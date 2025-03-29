import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  File? _image;
  String? _base64Image;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR from Image'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            if (_image != null)
              Column(
                children: [
                  Image.file(_image!, height: 200),
                  const SizedBox(height: 20),
                  const Text('QR Code containing the image:'),
                  const SizedBox(height: 10),
                  if (_base64Image != null)
                    QrImageView(
                      data: _base64Image!,
                      version: QrVersions.auto,
                      size: 200,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
