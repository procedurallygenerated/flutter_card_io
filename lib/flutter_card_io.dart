import 'dart:async';

import 'package:flutter/services.dart';

class FlutterCardIo {
  static const MethodChannel _channel =
      const MethodChannel('flutter_card_io');

  static Future<Map<String, dynamic>> scanCard(Map<String, dynamic> args) {
    return _channel.invokeMethod('scanCard', args);
  }

}
