import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel?> initializeWebSocket(String hostname) async {
  final wsUrl = Uri.parse('ws://$hostname:5000/echo');
  final channel = WebSocketChannel.connect(wsUrl);
  try{
    await channel.ready;
    return channel;
  } catch (e){
    print('error connecting to websocket');
  }
  return null;
}

void sendCommand(WebSocketChannel channel, String command){
  channel.sink.add(command);
}