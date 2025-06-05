
# tspl_flutter

A test Android app for the **Zenpert 3R20** thermal printer, communicating exclusively using **TSPL commands**.  
This project is built with Flutter and Dart.
# NOTE.
DPI = 203
pixel to millimetre  -> double
   mm = pixel * 25.4 / dpi 
mm to pixel -> integer
   pixel = (mm * dpi / 25.4).round()
    
## Features

- **Test and demo app** for the Zenpert 3R20 mobile printer.
- Send **raw TSPL commands** to the printer.
- Designed for testing, demo, and integration purposes.
- Supports Android devices.

## Requirements

- **Zenpert 3R20** printer (Bluetooth connection)
- Android device
- Flutter SDK (latest stable recommended)

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/tanongkiat/tspl_flutter.git
   cd tspl_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Connect your Zenpert 3R20 printer** to your Android device via Bluetooth.

4. **Run the app**
   ```bash
   flutter run
   ```

## Usage

- Launch the app on your Android device.
- Select your Zenpert 3R20 printer from the available Bluetooth devices.
- Input or select the TSPL command you wish to send.
- Press "Send" to transmit the command to the printer.
- The printer will execute the received TSPL command.

## Example TSPL Command

```tspl
SIZE 40 mm, 30 mm
GAP 2 mm, 0 mm
CLS
TEXT 20,20,"3",0,1,1,"Hello Zenpert 3R20"
PRINT 1
```

## Notes

- This project is for **testing and demonstration** only.
- Only **TSPL command mode** is supported (no ESC/POS, CPCL, etc.).
- Make sure your Android device has Bluetooth permissions enabled.

## License

MIT License

---

Let me know if you’d like to include more details, such as screenshots, contribution guidelines, or troubleshooting steps!
