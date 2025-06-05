import 'package:flutter/material.dart';

void main() {
  runApp(const PrinterAppWireframe());
}

class PrinterAppWireframe extends StatelessWidget {
  const PrinterAppWireframe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Printer Wireframe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Printer Home')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.bluetooth_searching),
            title: const Text('Scan for Devices'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScanScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Printer Settings'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrinterSettingsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan for Devices')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bluetooth, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text('Device List Placeholder'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Start Scan'),
            ),
          ],
        ),
      ),
    );
  }
}

class PrinterSettingsScreen extends StatelessWidget {
  const PrinterSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Printer Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Printer Settings Placeholder'),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(
        child: Text('Bluetooth Printer App\nVersion 1.0.0'),
      ),
    );
  }
}