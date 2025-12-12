import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'onnx_service.dart';
import 'image_processor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final detector = OnnxService();
  await detector.loadModel();
  runApp(MyApp(detector));
}

class MyApp extends StatefulWidget {
  final OnnxService detector;
  MyApp(this.detector);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _image;
  String _result = "Chọn ảnh để dự đoán";

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _predictDisease() async {
    if (_image == null) return;
    Float32List inputTensor = await processImage(_image!);
    String result = await widget.detector.predict(inputTensor);
    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Nhận diện bệnh trên lá lúa")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null ? Image.file(_image!, height: 200) : Placeholder(fallbackHeight: 200),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Chọn ảnh"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _predictDisease,
              child: Text("Dự đoán bệnh"),
            ),
          ],
        ),
      ),
    );
  }
}
