import tflite_runtime.interpreter as tflite
interpreter = tflite.Interpreter(model_path='assets/model/model.tflite')
interpreter.allocate_tensors()
print('Input:', interpreter.get_input_details()[0]['shape'])
print('Output:', interpreter.get_output_details()[0]['shape'])
