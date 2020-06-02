import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spherominicontroller/additional_widgets/MyTextButton.dart';
import 'package:spherominicontroller/utils/connectionStatus.dart';

import 'Sphero.dart';

class LoadSphero extends StatefulWidget {
  @override
  _LoadSpheroState createState() => _LoadSpheroState();
}

class _LoadSpheroState extends State<LoadSphero> {
  Function updateConnectionState;
  String connectionState;
  Sphero sphero = Sphero.getInstance();

  updateLocalConnectionState(String state) {
    if (mounted) setState(() => connectionState = state);
    updateConnectionState(state);
  }

  connectToSphero() {
    sphero.connect(updateLocalConnectionState);
  }

  disconnectFromSphero() {
    sphero.disconnect(callback: () => updateLocalConnectionState(ConnectionStatus.DISCONNECTED));
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
        title: Text("Sphero"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
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
                      ? "Sphero trennen"
                      : "Sphero verbinden",
                  press: () {
                    connectionState == ConnectionStatus.CONNECTED
                        ? disconnectFromSphero()
                        : connectToSphero();
                  },
                ),
        ],
      ),
    );
  }
}
