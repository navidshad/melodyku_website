import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:js/js_util.dart' as js;

void encodeToBase64(ByteBuffer buffer, Function(String encoded) callback)
{
  String encoded = base64.encode(buffer.asUint8List());
  callback(encoded);
}

class DownloadFile
{
  String contentType;
  ByteBuffer buffer;

  DownloadFile({this.contentType, this.buffer});

  factory DownloadFile.fromMap(Map detail)
  {
  	return DownloadFile(
  		contentType	: detail['contentType'],
  		buffer		  : Uint8List.fromList(detail['bytesList']).buffer
  	);
  }

  static Future<String> getBase64Link(String contentType, ByteBuffer buffer)
  {
    Completer<String> completer = Completer();

    encodeToBase64(buffer, (String encoded)
    {
      String header = 'data:${contentType};base64,';
      String src = '${header}${encoded}';
      print('base46 size: ${src.length}');

      completer.complete(src);
    });

  	return completer.future;
  }
}