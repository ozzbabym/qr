class Base64Checker {
  static bool isBase64Image(String data) {
    try {
      // Check if the string is valid base64
      final decodedBytes = base64.decode(data);
      
      // Try to decode as image
      final image = img.decodeImage(decodedBytes);
      return image != null;
    } catch (e) {
      return false;
    }
  }
}
