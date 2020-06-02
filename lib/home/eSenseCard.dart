import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spherominicontroller/additional_widgets/MyIconButton.dart';
import 'package:spherominicontroller/earable/direction.dart';

class ESenseCard extends StatelessWidget {
  final Function startListenToSensorEvents;
  final Function pauseListenToSensorEvents;
  final bool earableConnected;
  final bool earableActive;
  final Direction direction;

  ESenseCard(
      {this.startListenToSensorEvents,
      this.pauseListenToSensorEvents,
      this.earableConnected,
      this.earableActive,
      this.direction});

  @override
  Widget build(BuildContext context) {
    double angle = direction == null ? 0 : direction.getAngleRadian();
    double intensity = direction == null ? 0 : direction.getIntensityDouble();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("ESense Menü:",
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
                  icon: earableActive ? Icons.pause : Icons.play_arrow,
                  press: earableActive ? pauseListenToSensorEvents : startListenToSensorEvents,
                  color: earableConnected ? Colors.blue[300] : Colors.grey,
                  size: 30,
                  tooltip: "start and stop the sensoring of the earables",
                ),
                MyIconButton(
                  icon: Icons.settings,
                  press: earableActive && direction != null ? direction.updateOffset : () {},
                  color: earableActive ? Colors.blue[300] : Colors.grey,
                  size: 30,
                  tooltip: "set the current head position as default position",
                ),
                Transform.rotate(
                  angle: earableActive ? angle : 0,
                  child: Icon(Icons.arrow_upward,
                      size: 50, color: earableActive ? Colors.grey[800] : Colors.grey),
                ),
                Transform.rotate(
                  angle: -pi / 2,
                  child: Container(
                    width: 50,
                    height: 15,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      value: earableActive ? intensity : 0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
