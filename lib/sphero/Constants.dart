class Constants {
  //used to wake up sphero and put it to sleep mode again
  //also used for movement commands
  static const String SERVICE_COMMAND = "00010001-574f-4f20-5370-6865726f2121";
  static const String CHA_COMMAND = "00010002-574f-4f20-5370-6865726f2121";

  static const String UUID_SERVICE_BATTERY = "0000180f-0000-1000-8000-00805f9b34fb";
  static const String UUID_CHARACTERISTIC_BATTERY = "00002a19-0000-1000-8000-00805f9b34fb";

  // initialize the sphero to listen to us and not immediately disconnect
  static const String SERVICE_INITIALIZE = "00020001-574f-4f20-5370-6865726f2121";
  static const String CHA_INITIALIZE = "00020005-574f-4f20-5370-6865726f2121";
  static const List<int> DATA_INITIALIZE = [
    0x75,
    0x73,
    0x65,
    0x74,
    0x68,
    0x65,
    0x66,
    0x6f,
    0x72,
    0x63,
    0x65,
    0x2e,
    0x2e,
    0x2e,
    0x62,
    0x61,
    0x6e,
    0x64
  ];
}
