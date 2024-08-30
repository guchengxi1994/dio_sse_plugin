
## Usage

### run python server

> python test/server.py

### dart

```dart
Dio dio = Dio();
  dio.interceptors.add(DioSsePlugin());

  try {
    final response = await dio.get("http://localhost:5000/sse",
        options: Options(
          responseType: ResponseType.stream, // 指定响应类型为流式
        ));

    await response.data.stream.forEach((data) {
      print('[dart] 收到了消息');
      // print('最终处理数据块: ${utf8.decode(data)} ');
    });
  } catch (e, s) {
    print('请求失败: $e    s: $s');
  }
```
