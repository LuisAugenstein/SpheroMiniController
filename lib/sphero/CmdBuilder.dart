//commandBuilder
class CmdBuilder {
  static const List<int> CMD_START_BYTES = [0x8d, 0x0a];
  static const List<int> CMD_END_BYTES = [0xd8];
  static const List<int> CMD_LED_BYTES = [0x1a, 0x0e];
  static const List<int> CMD_RAW_MOTOR_BYTES = [0x16, 0x01];
  static const List<int> CMD_ROLL_BYTES = [0x16, 0x07];

  static int counter = 1;

  int calculateChecksumByte(List<int> data) {
    int sum = data.fold(0, (n, x) => n + x);
    return ((((sum % 256) ^ 0xff) + data[0]) & 0xff);
  }

  List<int> createCommand(List<int> commandType, List<int> data) {
    //start + command + counter + data + checksum + end;
    List<int> command = List();
    command.addAll(CMD_START_BYTES);
    command.addAll(commandType);
    command.add(counter++ & 0xff);
    command.addAll(data);
    command.add(calculateChecksumByte(command.sublist(0, 5 + data.length)));
    command.addAll(CMD_END_BYTES);
    return command;
  }

  List<int> createMoveCommand(List<int> data) {
    return createCommand(CMD_RAW_MOTOR_BYTES, data);
  }

  List<int> createRollCommand(List<int> data) {
    return createCommand(CMD_ROLL_BYTES, data);
  }

  List<int> createLedCommand(List<int> data) {
    return createCommand(CMD_LED_BYTES, data);
  }
}
