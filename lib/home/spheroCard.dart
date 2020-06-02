import 'package:flutter/material.dart';
import 'package:spherominicontroller/additional_widgets/MyIconButton.dart';
import 'package:spherominicontroller/sphero/Sphero.dart';

class SpheroCard extends StatelessWidget {
  final Function stopSphero;
  final Function startDriveMode;
  final Function startRotationMode;
  final SpheroState spheroState;
  final bool earableActive;

  SpheroCard({
    this.startDriveMode,
    this.stopSphero,
    this.spheroState,
    this.earableActive,
    this.startRotationMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("Sphero Menü:",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[800],
                  )),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MyIconButton(
                  icon: Icons.stop,
                  press: spheroState == SpheroState.INACTIVE ||
                          !earableActive ||
                          spheroState == SpheroState.DISCONNECTED
                      ? () {}
                      : stopSphero,
                  color: spheroState == SpheroState.INACTIVE ||
                          !earableActive ||
                          spheroState == SpheroState.DISCONNECTED
                      ? Colors.grey
                      : Colors.blue[300],
                  size: 30,
                  tooltip: "deactivate the sphero",
                ),
                MyIconButton(
                  icon: Icons.power_settings_new,
                  press: spheroState == SpheroState.DRIVE_MODE ||
                          !earableActive ||
                          spheroState == SpheroState.DISCONNECTED
                      ? () {}
                      : startDriveMode,
                  color: spheroState == SpheroState.DRIVE_MODE ||
                          !earableActive ||
                          spheroState == SpheroState.DISCONNECTED
                      ? Colors.grey
                      : Colors.blue[300],
                  size: 30,
                  tooltip: "activate the sphero",
                ),
                MyIconButton(
                  icon: Icons.rotate_left,
                  press: spheroState == SpheroState.ROTATION_MODE ||
                          !earableActive ||
                          spheroState == SpheroState.DISCONNECTED
                      ? () {}
                      : startRotationMode,
                  color: spheroState == SpheroState.ROTATION_MODE ||
                          !earableActive ||
                          spheroState == SpheroState.DISCONNECTED
                      ? Colors.grey
                      : Colors.blue[300],
                  size: 30,
                  tooltip: "start rotation mode",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
