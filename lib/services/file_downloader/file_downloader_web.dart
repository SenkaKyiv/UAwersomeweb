import 'file_downloader_interface.dart';

class FileDownloaderWeb implements FileDownloader {
  @override
  Future<String?> downloadFile(String url) async {
    // Тут можна реалізувати специфічну логіку для веб (наприклад, виклик JS API або
    // інший підхід). Для демонстрації повертаємо сам URL як "локальний шлях".
    return url;
  }
}

final FileDownloader fileDownloader = FileDownloaderWeb();
