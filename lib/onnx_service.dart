import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

class OnnxService {
  late OrtSession _session;

  Future<void> loadModel() async {
    // Khởi tạo môi trường ONNX Runtime
    OrtEnv.instance.init();

    // Tải mô hình từ assets
    final modelData = await rootBundle.load(
      'assets/models/swin_transformer_rice_leafs.onnx',
    );
    final modelBytes = modelData.buffer.asUint8List();

    // Tạo phiên làm việc với mô hình
    final sessionOptions = OrtSessionOptions();
    _session = OrtSession.fromBuffer(modelBytes, sessionOptions);
  }

  Future<String> predict(Float32List inputTensorData) async {
    // Tạo tensor đầu vào
    final inputTensor = OrtValueTensor.createTensorWithDataList(
      inputTensorData,
      [1, 3, 224, 224], // Kích thước đầu vào của mô hình
    );

    // Chạy mô hình với OrtRunOptions
    final outputs = _session.run(
      OrtRunOptions(), // Thêm OrtRunOptions() vào đây để tránh lỗi
      {'input': inputTensor}, // Dữ liệu đầu vào
    );

    // Lấy tensor đầu ra
    final outputTensor = outputs.first as OrtValueTensor;

    // Kiểm tra kiểu dữ liệu của outputTensor.value
    if (outputTensor.value is List<List<double>>) {
      // Nếu đầu ra là danh sách 2D, lấy giá trị đầu tiên
      final List<List<double>> output2D =
          outputTensor.value as List<List<double>>;
      final List<double> outputData = output2D.first;
      return _getPredictedLabel(outputData);
    } else if (outputTensor.value is List<double>) {
      // Nếu đầu ra là danh sách 1D, dùng trực tiếp
      final List<double> outputData = outputTensor.value as List<double>;
      return _getPredictedLabel(outputData);
    } else {
      throw Exception(
        "Dữ liệu đầu ra của mô hình không hợp lệ: ${outputTensor.value.runtimeType}",
      );
    }
  }

  String _getPredictedLabel(List<double> outputData) {
    // Tìm index có giá trị cao nhất
    int predictedIndex = outputData.indexWhere(
      (e) => e == outputData.reduce((a, b) => a > b ? a : b),
    );

    print('============ ${predictedIndex}');

    // Danh sách nhãn tương ứng với mô hình
    List<String> labels = [
      'bacterial_leaf_blight',
      'brown_spot',
      'healthy',
      'leaf_blast',
      'narrow_brown_spot',
    ];

    return labels[predictedIndex];
  }
}
