import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() async {
  try {
    final interpreter = Interpreter.fromFile(File('/home/shivam/Projects/PPG_Glucose_APP/assets/model/model.tflite'));
    print('Input tensors:');
    for (var tensor in interpreter.getInputTensors()) {
      print('- ${tensor.name}: ${tensor.shape} (type: ${tensor.type})');
    }
    print('Output tensors:');
    for (var tensor in interpreter.getOutputTensors()) {
      print('- ${tensor.name}: ${tensor.shape} (type: ${tensor.type})');
    }
    exit(0);
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}
