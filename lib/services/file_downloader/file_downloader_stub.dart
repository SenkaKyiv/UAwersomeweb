import 'file_downloader_interface.dart';

class FileDownloaderStub implements FileDownloader {
  @override
  Future<String?> downloadFile(String url) async {
    throw UnsupportedError("File downloading is not supported on this platform.");
  }
}

final FileDownloader fileDownloader = FileDownloaderStub();
