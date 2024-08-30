library dio_sse_plugin;

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class DioSsePlugin extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.responseType == ResponseType.stream) {
      final List<int> buffer = [];

      final Stream<Uint8List> stream = response.data.stream;

      final transformedStream = stream.transform<Uint8List>(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            if (endsWithNewlineNewline(data)) {
              if (buffer.isNotEmpty) {
                buffer.addAll(data);
                if (endsWithNewlineNewline(buffer)) {
                  sink.add(Uint8List.fromList(buffer));
                  buffer.clear();
                  return;
                }
              }
              sink.add(data);
              buffer.clear();
            } else {
              buffer.addAll(data);
            }
          },
        ),
      );

      // 将新的流赋值给响应对象
      final transformedResponse = Response(
        requestOptions: response.requestOptions,
        data: ResponseBody(transformedStream, response.data.contentLength),
        statusCode: response.statusCode,
        headers: response.headers,
      );

      return handler.resolve(transformedResponse); // 继续处理响应
    }

    super.onResponse(response, handler);
  }

  bool endsWithNewlineNewline(List<int> bytes) {
    // 如果字节流长度小于2，显然不可能以 `\n\n` 结尾
    if (bytes.length < 2) {
      return false;
    }

    // 检查字节流的最后两个字节
    final lastByte = bytes[bytes.length - 1];
    final secondLastByte = bytes[bytes.length - 2];

    // 判断这两个字节是否分别为 `\n` (10)
    return lastByte == 10 && secondLastByte == 10;
  }
}
