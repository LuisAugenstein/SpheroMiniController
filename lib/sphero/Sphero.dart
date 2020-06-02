import 'dart:async';
import 'dart:collection';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:spherominicontroller/utils/connectionStatus.dart';

import 'CmdBuilder.dart';
import 'Constants.dart';
import 'command.dart';

enum SpheroState { DRIVE_MODE, ROTATION_MODE, INACTIVE, DISCONNECTED }

class Sphero {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final String _deviceName = "SM-DA6F";
  final CmdBuilder cmdBuilder = CmdBuilder();
  BluetoothDevice device;
  List<BluetoothService> _services;
  static Sphero _sphero = Sphero();
  Timer timer;
  Queue commandQueue = Queue();

  static Sphero getInstance() {
    return _sphero;
  }

  //starts or restarts commandExecution of the sphero
  start() {
    commandQueue.clear();
    bool ready = true;
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 30), (timer) async {
      if (commandQueue.isEmpty || !ready) return;
      ready = false;
      print("length: ${commandQueue.length}");
      Command command = commandQueue.removeLast();
      await _write(command.service, command.characteristic, command.commandData);
      ready = true;
    });
  }

  stop() {
    commandQueue.clear();
    move(0, 0);
    Timer(Duration(milliseconds: 100), () => timer?.cancel());
  }

  // find sphero and setup Bluetooth connection
  // when sphero is found connectedCallback is invoked
  void connect(callback) {
    flutterBlue.scanResults.listen((List<ScanResult> results) async {
      if (device != null) return;
      ScanResult result =
          results.firstWhere((e) => e.device.name == _deviceName, orElse: () => null);
      if (result == null) {
        callback(ConnectionStatus.DEVICE_NOT_FOUND);
      } else {
        device = result.device;
        callback(ConnectionStatus.DEVICE_FOUND);
        await device.connect();
        await flutterBlue.stopScan();
        callback(ConnectionStatus.CONNECTING);
        _services = await device.discoverServices();
        await initialize();
        callback(ConnectionStatus.CONNECTED);
      }
    });
    flutterBlue.startScan(timeout: Duration(seconds: 5));
  }

  //send a write command to the sphero
  _write(String serviceUUID, String characteristicUUID, List<int> data) async {
    BluetoothService service = _services.firstWhere((e) {
      return e.uuid.toString() == serviceUUID;
    });
    BluetoothCharacteristic characteristic = service.characteristics.firstWhere((e) {
      return e.uuid.toString() == characteristicUUID;
    });
    await characteristic.write(data);
  }

  writeChaCommand(List<int> data) async {
    await _write(Constants.SERVICE_COMMAND, Constants.CHA_COMMAND, data);
  }

  initialize() async {
    //initial call so that sphero doesn't disconnect immediately
    await _write(Constants.SERVICE_INITIALIZE, Constants.CHA_INITIALIZE, Constants.DATA_INITIALIZE);
    // magic numbers to initialize the sphero
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x0d, 0x00, 0xd5, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x0d, 0x01, 0xd4, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x11, 0x06, 0x04, 0xda, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x10, 0x05, 0xcd, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x04, 0x06, 0xab, 0x50, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x1e, 0x07, 0xbd, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x11, 0x00, 0x08, 0xdc, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x1e, 0x09, 0xbb, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x1e, 0x0a, 0xba, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x11, 0x06, 0x0b, 0xd3, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x1f, 0x27, 0x0c, 0xa3, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x11, 0x12, 0x0d, 0xc5, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x11, 0x28, 0x0e, 0xae, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x10, 0x0f, 0xc3, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x04, 0x10, 0xce, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x10, 0x11, 0xc1, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x04, 0x12, 0xcc, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x10, 0x13, 0xbf, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x04, 0x14, 0xca, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x10, 0x15, 0xbd, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x04, 0x16, 0xc8, 0xd8]);
  }

  void disconnect({callback}) async {
    stop();
    //magic numbers to shut down the sphero
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x01, 0x06, 0xdb, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x02, 0x07, 0xd9, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x03, 0x08, 0xd7, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x04, 0x09, 0xd5, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x05, 0x0a, 0xd3, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x06, 0x0b, 0xd1, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x07, 0x0c, 0xcf, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x08, 0x0d, 0xcd, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x09, 0x0e, 0xcb, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x0a, 0x0f, 0xc9, 0xd8]);
    await writeChaCommand([0x8d, 0x0a, 0x13, 0x0b, 0x10, 0xc7, 0xd8]);
    //disconnect the bluetooth connection
    device.disconnect();
    _services = null;
    device = null;
    callback();
  }

  move(int left, int right) {
    // get the direction based on positive/negative values for left & right motors
    int leftDir = left > 0 ? 0x01 : 0x02;
    int rightDir = right > 0 ? 0x01 : 0x02;
    // chop off sign on left & right power levels since it was only used to indicate forward/backward
    left = left.abs();
    right = right.abs();
    List<int> data = [leftDir, left & 0xff, rightDir, right & 0xff];
    List<int> commandData = cmdBuilder.createMoveCommand(data);
    commandQueue.addFirst(Command(
        commandData: commandData,
        service: Constants.SERVICE_COMMAND,
        characteristic: Constants.CHA_COMMAND));
  }

  roll(int speed, int heading, int aim) {
    heading = (aim + heading) % 360;
    int headingByte1 = heading & 0xff; // 360: 104
    int headingByte2 = (heading >> 8) & 0xff; // 360:
    speed = speed & 0xff;
    List<int> data = [speed, headingByte2, headingByte1, 0x00];
    List<int> commandData = cmdBuilder.createRollCommand(data);
    commandQueue.addFirst(Command(
        commandData: commandData,
        service: Constants.SERVICE_COMMAND,
        characteristic: Constants.CHA_COMMAND));
  }

  rearLedOn(bool on) {
    int brightness = on ? 0xff : 0x00;
    List<int> data = [0x00, 0x01, brightness];
    List<int> commandData = cmdBuilder.createLedCommand(data);
    commandQueue.addFirst(Command(
        commandData: commandData,
        service: Constants.SERVICE_COMMAND,
        characteristic: Constants.CHA_COMMAND));
  }
}
