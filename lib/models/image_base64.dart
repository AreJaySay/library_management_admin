import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class ImageConverter {
  Future<String> fileToBase64(String filePath) async {
    try {
      File file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist at path: $filePath');
      }
      Uint8List bytes = await file.readAsBytes();
      String base64String = base64Encode(bytes as List<int>);
      return base64String;
    } catch (e) {
      print('Error converting file to Base64: $e');
      return ''; // Or handle the error appropriately
    }
  }
}
final ImageConverter imageConverter = new ImageConverter();