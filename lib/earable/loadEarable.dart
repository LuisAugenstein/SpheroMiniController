import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spherominicontroller/additional_widgets/MyTextButton.dart';
import 'package:spherominicontroller/utils/connectionStatus.dart';

class LoadEarable extends StatefulWidget {
  @override
  _LoadEarableState createState() => _LoadEarableState();
}

class _LoadEarableState extends State<LoadEarable> {
  String eSenseName = 'eSense-0151';
  Function updateConnectionState;
  String connectionState;

  void updateLocalConnectionState(String state) {
    if (mounted) setState(() => connectionState = state);
    updateConnectionState(state);
  }

  connectToESense() async {
    ESenseManager.connectionEvents.listen((event) {
      switch (event.type) {
        case ConnectionType.connected:
          updateLocalConnectionState(ConnectionStatus.CONNECTED);
          break;
        case ConnectionType.device_found:
          updateLocalConnectionState(ConnectionStatus.DEVICE_FOUND);
          break;
        case ConnectionType.disconnected:
          updateLocalConnectionState(ConnectionStatus.DISCONNECTED);
          break;
        case ConnectionType.device_not_found:
          updateLocalConnectionState(ConnectionStatus.DEVICE_NOT_FOUND);
          break;
        case ConnectionType.unknown:
          break;
      }
    });
    updateLocalConnectionState(ConnectionStatus.CONNECTING);
    ESenseManager.connect(eSenseName);
  }

  disconnectFromESense() {
    updateLocalConnectionState(ConnectionStatus.DISCONNECTED);
    ESenseManager.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    if (connectionState == null) {
      Map data = ModalRoute.of(context).settings.arguments;
      connectionState = data['connectionState'];
      updateConnectionState = data['updateConnectionState'];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("ESense"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          connectionState == ConnectionStatus.CONNECTING ||
                  connectionState == ConnectionStatus.DEVICE_FOUND
              ? SpinKitFoldingCube(
                  color: Colors.blue[900],
                  size: 50,
                )
              : Icon(
                  connectionState == ConnectionStatus.CONNECTED ? Icons.beenhere : Icons.sms_failed,
                  size: 50,
                  color: connectionState == ConnectionStatus.CONNECTED
                      ? Colors.green[500]
                      : Colors.red[400],
                ),
          SizedBox(height: 20),
          Center(
            child: Text(
              connectionState,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 30,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(height: 70),
          connectionState == ConnectionStatus.CONNECTING ||
                  connectionState == ConnectionStatus.DEVICE_FOUND
              ? Container()
              : MyTextButton(
                  text: connectionState == ConnectionStatus.CONNECTED
                      ? "Earable trennen"
                      : "Earable verbinden",
                  press: () {
                    connectionState == ConnectionStatus.CONNECTED
                        ? disconnectFromESense()
                        : connectToESense();
                  },
                ),
        ],
      ),
    );
  }
}
