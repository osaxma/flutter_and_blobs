// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'dart:typed_data';

/* doesn't work for web but works for mobile to convert url to bytes. 
import 'package:flutter/services.dart';
Future<Uint8List> convertUrlToBytes(String url) async {
  final bytes = await NetworkAssetBundle(Uri.parse(url)).load(url);
  return bytes.buffer.asUint8List();
}
*/

Future<Blob> convertBase64ToBlob([String base64image]) async {
  final response = await window.fetch(base64image);
  final blob = await response.blob();
  return blob;
}

String convertBlobToUrl(Blob blob) {
  return Url.createObjectUrl(blob);
}


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
