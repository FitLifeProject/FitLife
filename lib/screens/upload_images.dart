import 'dart:convert';
import 'dart:io';
import 'package:fitlife/models/model.dart';
import 'package:flimer/flimer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ImgurUploader extends StatefulWidget {
  const ImgurUploader({super.key});

  @override
  State<ImgurUploader> createState() => _ImgurUploaderState();
}

class _ImgurUploaderState extends State<ImgurUploader> {
  File? _imageFile;
  String? _imgurUrl;

  Future<void> _pickImage() async {
    final result = await flimer.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        _imageFile = File(result.path);
      });
    }
  }

  Future<void> _uploadImage(model) async {
    final bytes = await _imageFile!.readAsBytes();
    final base64Image = base64.encode(bytes);

    final response = await http.post(
      Uri.parse('https://api.imgur.com/3/image'),
      headers: {'Authorization': 'Client-ID 4236173c2587578'},
      body: {'image': base64Image},
    );

    final responseData = jsonDecode(response.body)['data'];
    final imgUrl = responseData['link'];
    model.uploadGymPFP(imgUrl);

    setState(() {
      _imgurUrl = imgUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imgur Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(_imageFile!, height: 200.0)
                : const Text('No image selected.'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _imageFile != null ? _uploadImage(model) : null;
              },
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 16.0),
            _imgurUrl != null
                ? Image.network(_imgurUrl!, height: 200.0)
                : const Text('No image uploaded.'),
          ],
        ),
      ),
    );
  }
}
