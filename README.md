---

# tspl_flutter

A cross-platform Flutter application for connecting to and printing from Bluetooth printers, supporting TSPL (Thermal Printer Command Language) devices. This project is primarily written in Dart, with native integrations in C++, CMake, Ruby, Swift, and C for platform-specific functionalities.

## Features

- Discover and connect to Bluetooth printers
- Send print commands using TSPL/ESC/POS
- Cross-platform support (Android, iOS, and more)
- Easy-to-use Flutter interface

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Compatible Bluetooth printer (TSPL/ESC/POS)
- Device with Bluetooth capability

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/tanongkiat/tspl_flutter.git
   cd tspl_flutter
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Connect your device and run:
   ```bash
   flutter run
   ```

### Usage

1. Launch the app on your device.
2. Scan for available Bluetooth printers.
3. Select a printer and connect.
4. Send text or image data to print using TSPL commands.

## Project Structure

- `lib/` — Flutter (Dart) code for UI and logic
- `android/`, `ios/` — Native code and platform integration
- `cpp/`, `cmake/` — Native modules for printer communication
- `test/` — Unit and widget tests

## Contributing

Contributions are welcome! Please open issues or submit pull requests.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [TSPL Command Reference](https://www.tecton.com.tw/download/TSPL_MANUAL.pdf)

---

Let me know if you want to customize this further (e.g., add screenshots, API usage, or more detailed features)!
