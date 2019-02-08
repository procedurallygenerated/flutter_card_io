import 'dart:async';

import 'package:flutter/services.dart';

class FlutterCardIo {
  static const MethodChannel _channel = const MethodChannel('flutter_card_io');

  static Future<dynamic> scanCard(Map<String, dynamic> args) {
    return _channel.invokeMethod('scanCard', args);
  }
}
