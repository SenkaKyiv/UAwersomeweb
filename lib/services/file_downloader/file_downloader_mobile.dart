import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'file_downloader_interface.dart';

class FileDownloaderMobile implements FileDownloader {
  @override
  Future<String?> downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        // Витягуємо ім'я файлу з URL
        final fileName = url.split('/').last.split('?').first;
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      print("Error downloading file: $e");
    }
    return null;
  }
}

final FileDownloader fileDownloader = FileDownloaderMobile();
