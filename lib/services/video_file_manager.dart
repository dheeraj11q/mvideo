import 'dart:io';
import 'dart:typed_data';

class VideoFileManager {
  static Future<String> writeData(dataToWrite, fileNameWithPath) async {
    print("writing ...");
    File f = File(fileNameWithPath);
    await f.writeAsBytes(dataToWrite);

    print("writing done ...");
    return f.absolute.toString();
  }

  static Future<Uint8List> readData(fileNameWithPath) async {
    print("reading ...");
    File f = File(fileNameWithPath);
    return await f.readAsBytes();
  }

// < dir and a path  "enc" || "dec"

  static Future<Directory> getExternalVisibleDir(String dir) async {
    if (await Directory('/storage/emulated/0/Mvideo/$dir').exists()) {
      final externalDir = Directory('/storage/emulated/0/Mvideo/$dir');
      return externalDir;
    } else {
      await Directory('/storage/emulated/0/Mvideo/$dir')
          .create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/Mvideo/$dir');
      return externalDir;
    }
  }
}
