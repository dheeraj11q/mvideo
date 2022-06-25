import 'dart:isolate';
import 'package:encrypt/encrypt.dart' as enc;

class Encryption {
  static final myKey = enc.Key.fromUtf8("my32lengthsupersecretnooneknows1");
  static final myIv = enc.IV.fromLength(16);
  static final myEncrypt = enc.Encrypter(enc.AES(myKey));
}

// <

encryptDataWithIsolate(Map<String, dynamic> data) {
  SendPort sendPort = data["port"];
  var mapData = data["data"];

  final encrypted =
      Encryption.myEncrypt.encryptBytes(mapData, iv: Encryption.myIv);

  sendPort.send(encrypted.bytes);
}

// <

decryptDataWithIsolate(Map<String, dynamic> data) {
  SendPort sendPort = data["port"];
  var mapData = data["data"];

  enc.Encrypted en = enc.Encrypted(mapData);
  var decData = Encryption.myEncrypt.decryptBytes(en, iv: Encryption.myIv);

  sendPort.send(decData);
}
