# Example for using blobs in Flutter Web

- convert Base64 to Blob
```dart
import 'dart:html';
Future<Blob> convertBase64ToBlob([String base64image]) async {
  final response = await window.fetch(base64image);
  final blob = await response.blob();
  return blob;
}
```
- convert Blob to Uint8List
```dart
import 'dart:html';
Future<Uint8List> convertBlobUrlToBytes(String url, [bool revokeUrl = false]) async {
  // send a request to retrieve the blob
  final xhr = HttpRequest();
  xhr.responseType = 'blob';
  xhr.open('GET', url);
  xhr.send();
  // wait for result
  await xhr.onLoad.first;
  final recoveredBlob = xhr.response;

  // read the data as Uint8List
  final reader = FileReader();
  reader.readAsArrayBuffer(recoveredBlob);
  await reader.onLoad.first;
  final data = reader.result;

  if (revokeUrl) {
    Url.revokeObjectUrl(url);
  }
  return data;
}
```
- convert Blob To Object Url (e.g. `blob:http://domain/path/to/object`)
```dart
import 'dart:html';
String convertBlobToUrl(Blob blob) {
  return Url.createObjectUrl(blob);
}
```


![some image](/web/sample.png)



for mobile, a url can be converted to bytes as follow:
```dart
import 'package:flutter/services.dart';
// doesn't work on web since NetworkAssetBundle uses dart:io. 
Future<Uint8List> convertUrlToBytes(String url) async {
  final bytes = await NetworkAssetBundle(Uri.parse(url)).load(url);
  return bytes.buffer.asUint8List();
}
```