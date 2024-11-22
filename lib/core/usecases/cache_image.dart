import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> cacheImageFromUrl(String imageUrl, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';

  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  } else {
    throw Exception('Failed to download image');
  }
}

Future<String> cacheImageFromFile(File imageFile) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/${imageFile.uri.pathSegments.last}';

  final bytes = await imageFile.readAsBytes();
  final file = File(filePath);
  await file.writeAsBytes(bytes);

  return filePath;
}
