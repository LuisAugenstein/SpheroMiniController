import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spherominicontroller/home/spheroCard.dart';
import 'package:spherominicontroller/sphero/Sphero.dart';
import 'package:spherominicontroller/utils/connectionStatus.dart';

import '../earable/direction.dart';
import 'connectionCard.dart';
import 'eSenseCard.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Direction direction;
  String spheroConnectionState = ConnectionStatus.DISCONNECTED;
  String eSenseConnectionState = ConnectionStatus.DISCONNECTED;
  Sphero sphero = Sphero.getInstance();
  StreamSubscription subscription;
  bool earableActive = false;
  SpheroState spheroState = SpheroState.DISCONNECTED;
  Timer timer;

  updateSpheroConnectionState(String state) {
    setState(() {
      spheroConnectionState = state;
      spheroState =
          state == ConnectionStatus.CONNECTED ? SpheroState.INACTIVE : SpheroState.DISCONNECTED;
    });
  }

  updateESenseConnectionState(String state) {
    setState(() {
      eSenseConnectionState = state;
      if (state != ConnectionStatus.CONNECTED) pauseListenToSensorEvents();
    });
  }

  startListenToSensorEvents() async {
    if (eSenseConnectionState != ConnectionStatus.CONNECTED) return;
    subscription = ESenseManager.sensorEvents.listen((event) {
      setState(() => direction = Direction(event.accel));
    });
    setState(() => earableActive = true);
  }

  pauseListenToSensorEvents() async {
    subscription?.cancel();
    setState(() => earableActive = false);
  }

  startDrivingMode() {
    if (spheroState == SpheroState.DRIVE_MODE) return;
    setState(() => spheroState = SpheroState.DRIVE_MODE);
    sphero.start();
    sphero.rearLedOn(false);
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 130), (timer) {
      if (sphero.commandQueue.length > 5) return;
      if (spheroState != SpheroState.DRIVE_MODE || direction == null || !earableActive) {
        sphero.move(0, 0);
        return;
      }
      print(direction.getIntensityInt());
      sphero.roll(
          direction.getIntensityInt(), direction.getAngleDegree(), direction.getAimDegree());
    });
  }

  startInactiveMode() {
    if (spheroState == SpheroState.INACTIVE) return;
    setState(() => spheroState = SpheroState.INACTIVE);
    sphero.stop();
    sphero.rearLedOn(false);
    timer?.cancel();
  }

  startRotationMode() {
    if (spheroState == SpheroState.ROTATION_MODE) return;
    setState(() => spheroState = SpheroState.ROTATION_MODE);
    sphero.start();
    sphero.rearLedOn(true);
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 130), (timer) {
      if (sphero.commandQueue.length > 5) return;
      if (spheroState != SpheroState.ROTATION_MODE || direction == null || !earableActive) {
        sphero.move(0, 0);
        return;
      }
      direction.updateAim();
      sphero.roll(0, direction.getAimDegree(), 0);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    ESenseManager.disconnect();
    sphero.disconnect();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Sphero Navigator'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 10, 6, 0),
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? portraitMode()
              : landscapeMode(),
        ),
      ),
    );
  }

  Widget portraitMode() {
    return Column(
      children: [
        ConnectionCard(
            eSenseConnectionState: eSenseConnectionState,
            spheroConnectionState: spheroConnectionState,
            updateESenseConnectionState: updateESenseConnectionState,
            updateSpheroConnectionState: updateSpheroConnectionState),
        ESenseCard(
          earableActive: earableActive,
          earableConnected: eSenseConnectionState == ConnectionStatus.CONNECTED,
          direction: direction,
          pauseListenToSensorEvents: pauseListenToSensorEvents,
          startListenToSensorEvents: startListenToSensorEvents,
        ),
        SpheroCard(
          stopSphero: startInactiveMode,
          startDriveMode: startDrivingMode,
          startRotationMode: startRotationMode,
          spheroState: spheroState,
          earableActive: earableActive,
        ),
      ],
    );
  }

  landscapeMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: ConnectionCard(
                  eSenseConnectionState: eSenseConnectionState,
                  spheroConnectionState: spheroConnectionState,
                  updateESenseConnectionState: updateESenseConnectionState,
                  updateSpheroConnectionState: updateSpheroConnectionState),
            ),
            Expanded(
              child: ESenseCard(
                earableActive: earableActive,
                earableConnected: eSenseConnectionState == ConnectionStatus.CONNECTED,
                direction: direction,
                pauseListenToSensorEvents: pauseListenToSensorEvents,
                startListenToSensorEvents: startListenToSensorEvents,
              ),
            ),
          ],
        ),
        SpheroCard(
          stopSphero: startInactiveMode,
          startDriveMode: startDrivingMode,
          startRotationMode: startRotationMode,
          spheroState: spheroState,
          earableActive: earableActive,
        ),
      ],
    );
  }
}
