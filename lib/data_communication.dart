import 'dart:async';
import 'package:flutter/services.dart';

class DataCommunication {
  // Singleton instance
  static final DataCommunication _instance = DataCommunication._internal();

  factory DataCommunication() {
    return _instance;
  }

  DataCommunication._internal();

  // Method channel for communicating with native code
  final MethodChannel _channel = const MethodChannel('com.zanis.data_communication');

  // Stream controller for data events
  final StreamController<Map<String, dynamic>> _dataStreamController =
  StreamController<Map<String, dynamic>>.broadcast();

  // Stream getter for listening to data events
  Stream<Map<String, dynamic>> get dataStream => _dataStreamController.stream;

  // Initialize the communication
  Future<void> initialize() async {
    // Set up method call handler
    _channel.setMethodCallHandler(_handleMethodCall);

    // Start listening for data
    await startListening();
  }

// Handle method calls from native code
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onDataReceived':
      // Handle received data
        final data = Map<String, dynamic>.from(call.arguments as Map);
        _dataStreamController.add(data);
        break;
      default:
        print('Unknown method ${call.method}');
    }
  }

  // Start listening for data
  Future<bool> startListening() async {
    try {
      final bool result = await _channel.invokeMethod('startDataListening');
      return result;
    } on PlatformException catch (e) {
      print('Failed to start listening: ${e.message}');
      return false;
    }
  }

  // Stop listening for data
  Future<bool> stopListening() async {
    try {
      final bool result = await _channel.invokeMethod('stopDataListening');
      return result;
    } on PlatformException catch (e) {
      print('Failed to stop listening: ${e.message}');
      return false;
    }
  }

  // Get device info
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final result = await _channel.invokeMethod('getDeviceInfo');

      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print('Failed to get device info: ${e.message}');
      return {};
    }
  }

  // Dispose resources
  void dispose() {
    _dataStreamController.close();
  }
}