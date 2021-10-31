import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/io.dart';

void main(List<String> arguments) {
  final channel = IOWebSocketChannel.connect(
      'wss://ws.binaryws.com/websockets/v3?app_id=1089');

  channel.stream.listen((message) {
    final decodedMessage = jsonDecode(message);
    if (decodedMessage['tick'] != null) {
      final name = decodedMessage['tick']['symbol'];
      final price = decodedMessage['tick']['quote'];
      final epochTime = decodedMessage['tick']['epoch'];
      final time = DateTime.fromMillisecondsSinceEpoch(epochTime * 1000);

      print('Name: $name, Price: $price, Date: $time');
    } else if (decodedMessage['error'] != null) {
      print(decodedMessage['error']['message']);
    }
  });

  print('Please Enter Symbol Name : ');
  final userInput = stdin.readLineSync();
  channel.sink.add('{"ticks":"$userInput"}');
}
