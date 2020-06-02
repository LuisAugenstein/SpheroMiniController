import 'package:flutter/material.dart';
import 'package:spherominicontroller/additional_widgets/MyIconButton.dart';
import 'package:spherominicontroller/utils/connectionStatus.dart';

class ConnectionCard extends StatelessWidget {
  final String spheroConnectionState;
  final String eSenseConnectionState;
  final Function updateESenseConnectionState;
  final Function updateSpheroConnectionState;

  ConnectionCard(
      {this.spheroConnectionState,
      this.eSenseConnectionState,
      this.updateESenseConnectionState,
      this.updateSpheroConnectionState});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Text("Geräte verbinden:",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[400],
                )),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyIconButton(
                  color: eSenseConnectionState == ConnectionStatus.CONNECTED
                      ? Colors.green
                      : Colors.red,
                  icon: Icons.headset,
                  press: () {
                    Navigator.pushNamed(context, "/loadEarable", arguments: {
                      'updateConnectionState': updateESenseConnectionState,
                      'connectionState': eSenseConnectionState,
                    });
                  },
                ),
                SizedBox(width: 20),
                MyIconButton(
                  color: spheroConnectionState == ConnectionStatus.CONNECTED
                      ? Colors.green
                      : Colors.red,
                  icon: IconData(0xe800, fontFamily: "Sphero"),
                  press: () async {
                    await Navigator.pushNamed(context, "/loadSphero", arguments: {
                      'updateConnectionState': updateSpheroConnectionState,
                      'connectionState': spheroConnectionState,
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
