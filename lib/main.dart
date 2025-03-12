import 'package:flutter/material.dart';
import 'data_communication.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zanis Data Communication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DataScreen(),
    );
  }
}

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final DataCommunication _dataCommunication = DataCommunication();
  final List<Map<String, dynamic>> _receivedData = [];
  Map<String, dynamic> _deviceInfo = {};
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCommunication();
  }

  Future<void> _initializeCommunication() async {
    // Initialize the communication layer
    await _dataCommunication.initialize();

    // Listen for data events
    _dataCommunication.dataStream.listen((data) {
      setState(() {
        // Keep only the last 20 entries
        if (_receivedData.length >= 20) {
          _receivedData.removeAt(0);
        }
        _receivedData.add(data);
      });
    });

    // Get device info
    final deviceInfo = await _dataCommunication.getDeviceInfo();

    setState(() {
      _deviceInfo = deviceInfo;
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _dataCommunication.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zanis Data Communication'),
      ),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Device info section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Device Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._deviceInfo.entries.map((entry) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Text(
                                '${entry.key}: ',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('${entry.value}'),
                            ],
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Data section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Received Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _dataCommunication.startListening();
                            },
                            child: const Text('Start'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              _dataCommunication.stopListening();
                            },
                            child: const Text('Stop'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _receivedData.isEmpty
                        ? const Center(child: Text('No data received yet'))
                        : ListView.builder(
                      itemCount: _receivedData.length,
                      itemBuilder: (context, index) {
                        final data = _receivedData[_receivedData.length - 1 - index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...data.entries.map((entry) =>
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${entry.key}: ',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text('${entry.value}'),
                                        ],
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}