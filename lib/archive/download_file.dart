import 'dart:convert';
import 'dart:typed_data';
import 'package:js/js_util.dart' as js;

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

  static String getBase64Link(String contentType, ByteBuffer buffer)
  {
    // List<int> bytes = [];

    // bytesList.forEach((item) => bytes.add(item));

    String header = 'data:${contentType};base64,';
  	String data = base64.encode(buffer.asUint8List());
  	String src = '${header}${data}';
  	return src;
  }
}