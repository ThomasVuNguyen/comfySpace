import 'dart:convert';
import 'dart:io';

void CameraFunction1() async {
  Uri apiUrl = Uri.parse('http://192.168.1.1/osc/commands/execute');
  var client = HttpClient();
  Map<String, String> body = {'name': 'camera.getLivePreview'};
  var request = await client.postUrl(apiUrl)
    ..headers.contentType = ContentType("application", "json", charset: "utf-8")
    ..write(jsonEncode(body));
  var response = await request.close();
  response.listen((List<int> data) {
    print(data);
  });
}