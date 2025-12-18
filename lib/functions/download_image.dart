import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

void downloadUint8ListAsFile(Uint8List data, String filename) {
  final blob = web.Blob(
      // ignore: invalid_runtime_check_with_js_interop_types
      [data] as JSArray<JSAny>,
      web.BlobPropertyBag(
        type: 'img',
        // endings: 'jpg',
      ));
  final url = web.URL.createObjectURL(blob);
  web.HTMLAnchorElement()
    ..setAttribute('href', url)
    ..setAttribute('download', '$filename.jpg')
    ..click();
  web.URL.revokeObjectURL(url);
}

// How to use it:
// Uint8List myData = Uint8List.fromList([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]);
// downloadUint8ListAsFile(myData, 'hello.txt');
