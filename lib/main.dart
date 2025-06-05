import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'print_text_page.dart';
import 'printer.dart'; // Make sure you have your BluetoothScanPage in printer.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Blue Plus Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Printer Demo')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Start Printer App'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BluetoothScanPage()),
            );
          },
        ),
      ),
    );
  }
}

class BluetoothScanPage extends StatefulWidget {
  const BluetoothScanPage({super.key});

  @override
  State<BluetoothScanPage> createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  bool _isBluetoothOn = false;
  bool _isLoading = true;
  late final Stream<BluetoothAdapterState> _stateStream;
  bool _isConnected = false;
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _serialCharacteristic;

  // These are common for serial profile on many Bluetooth modules (e.g., HC-08, HM-10, some printers)
  static const String serialServiceUUID =
      "49535343-fe7d-4ae5-8fa9-9fafd205e455"; //fff0";
  static const String serialCharUUID =
      "49535343-8841-43f4-a8d4-ecbe34729bb3"; //fff2"; // fff1 is no write property

  @override
  void initState() {
    super.initState();
    _ensurePermissions().then((_) {
      _stateStream = FlutterBluePlus.adapterState;
      _listenBluetoothState();
    });
  }

  Future<void> _ensurePermissions() async {
    await Permission.location.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  void _listenBluetoothState() {
    _stateStream.listen((state) async {
      final isOn = state == BluetoothAdapterState.on;
      setState(() {
        _isBluetoothOn = isOn;
        _isLoading = false;
      });
      if (isOn && !_isConnected) {
        await FlutterBluePlus.stopScan();
        // Wait a bit for the OS to initialize Bluetooth hardware
        await Future.delayed(const Duration(seconds: 2));
        FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));
      } else {
        await FlutterBluePlus.stopScan();
      }
    });
    // Initial check
    FlutterBluePlus.isOn.then((isOn) {
      setState(() {
        _isBluetoothOn = isOn;
        _isLoading = false;
      });
      if (isOn && !_isConnected) {
        FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      }
    });
  }

  void _refreshScan() {
    if (_isBluetoothOn) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      setState(() {});
    }
  }

  Future<void> _connectSerial(BluetoothDevice device) async {
    try {
      await device.connect();
      // If pairing is required, the system will prompt for a PIN.
      // You can show a dialog here to instruct the user:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'If prompted, please enter the PIN in the system dialog.',
          ),
        ),
      );

      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        debugPrint('Service: ${service.uuid}');
        for (var characteristic in service.characteristics) {
          debugPrint('Characteristic: ${characteristic.uuid}');
          debugPrint('  Properties: ${characteristic.properties}');
        }
      }
      final service = services.firstWhere(
        (s) => s.uuid.str.toLowerCase() == serialServiceUUID,
        orElse: () => throw Exception('Serial service not found'),
      );
      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid.str.toLowerCase() == serialCharUUID,
        orElse: () => throw Exception('Serial characteristic not found'),
      );
      setState(() {
        _isConnected = true;
        _connectedDevice = device;
        _serialCharacteristic = characteristic;
      });
      await FlutterBluePlus.stopScan();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to ${device.platformName}')),
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PrintTextPage(
            serialCharacteristic: _serialCharacteristic!,
            device: _connectedDevice!,
          ),
        ),
      );
      setState(() {
        _isConnected = false;
        _connectedDevice = null;
        _serialCharacteristic = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to connect: $e')));
    }
  }

  Future<String?> _showPinDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter PIN'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'PIN'),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Bluetooth Devices')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_isBluetoothOn
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bluetooth is off. Please enable Bluetooth.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await FlutterBluePlus.turnOn();
                    },
                    child: const Text('Turn On Bluetooth'),
                  ),
                ],
              ),
            )
          : _isConnected
          ? const Center(child: Text('Connected to printer.'))
          : StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.scanResults,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final results = snapshot.data!;
                if (results.isEmpty) {
                  return const Center(child: Text('No devices found.'));
                }
                // Sort by RSSI descending (strongest signal first)
                results.sort((a, b) => b.rssi.compareTo(a.rssi));
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final scanResult = results[index];
                    final device = scanResult.device;

                    // Print all Bluetooth parameters for debugging
                    // print('--- Bluetooth Device ---');
                    // print('Name: ${device.platformName}');
                    // print('Address: ${device.remoteId.str}');
                    // print('RSSI: ${scanResult.rssi}');
                    // print('Adv Name: ${scanResult.advertisementData.advName}');
                    // print('Service UUIDs: ${scanResult.advertisementData.serviceUuids}');
                    // print('Manufacturer Data: ${scanResult.advertisementData.manufacturerData}');
                    // print('Tx Power Level: ${scanResult.advertisementData.txPowerLevel}');
                    // print('Connectable: ${scanResult.advertisementData.connectable}');
                    // print('Raw Advertisement Data: ${scanResult.advertisementData}');

                    String type = 'Unknown';
                    if (device.platformName.toLowerCase().contains('phone')) {
                      type = 'Phone';
                    } else if (device.platformName.toLowerCase().contains(
                      'printer',
                    )) {
                      type = 'Printer';
                    } else if (device.platformName.toLowerCase().contains(
                          'headphone',
                        ) ||
                        device.platformName.toLowerCase().contains('headset')) {
                      type = 'Headphone';
                    } else if (scanResult.advertisementData.serviceUuids.any(
                      (uuid) =>
                          uuid.toString().toLowerCase().contains('printer'),
                    )) {
                      type = 'Printer';
                    }

                    final advName = scanResult.advertisementData.advName;
                    final address = device.remoteId.str;
                    final name = advName.isNotEmpty ? advName : address;
                    if (advName.isEmpty) {
                      return const SizedBox.shrink();
                    } else {
                      return ListTile(
                        leading: const Icon(Icons.bluetooth),
                        title: Text(name),
                        subtitle: Text('$address • RSSI: ${scanResult.rssi}'),
                        onTap: () async {
                          final shouldConnect = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Pair and Connect'),
                              content: Text(
                                'Do you want to pair and connect to "$name"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Connect'),
                                ),
                              ],
                            ),
                          );
                          if (shouldConnect == true) {
                            await _connectSerial(device);
                          }
                        },
                      );
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: _refreshScan,
        tooltip: 'Rescan',
      ),
    );
  }
}
