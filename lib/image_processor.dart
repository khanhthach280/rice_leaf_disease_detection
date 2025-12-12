import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

// Future<Float32List> processImage(File imageFile) async {
//   img.Image image = img.decodeImage(await imageFile.readAsBytes())!;
//   img.Image resized = img.copyResize(image, width: 224, height: 224);

//   List<double> imageTensor = [];
//   for (int y = 0; y < 224; y++) {
//     for (int x = 0; x < 224; x++) {
//       final pixel = resized.getPixel(x, y);
//       imageTensor.addAll([
//         pixel.r / 255.0, 
//         pixel.g / 255.0, 
//         pixel.b / 255.0  
//       ]);
//     }
//   }
//   return Float32List.fromList(imageTensor);
// }

Future<Float32List> processImage(File imageFile) async {
  final bytes = await imageFile.readAsBytes();
  final img.Image image = img.decodeImage(bytes)!;
  final img.Image resized = img.copyResize(image, width: 224, height: 224);

  final Float32List input = Float32List(3 * 224 * 224);
  int index = 0;

  for (int c = 0; c < 3; c++) { // Channel first (CHW)
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);
        double value;
        if (c == 0) {
          value = pixel.r / 255.0;
        } else if (c == 1) {
          value = pixel.g / 255.0;
        } else {
          value = pixel.b / 255.0;
        }
        // Chuẩn hóa: (value - 0.5) / 0.5 = value * 2 - 1
        input[index++] = value * 2.0 - 1.0;
      }
    }
  }

  return input;
}

