abstract class FileDownloader {
  /// Завантажує файл за [url] і повертає локальний шлях (або інший ідентифікатор)
  /// якщо завантаження успішне, інакше повертає null.
  Future<String?> downloadFile(String url);
}
