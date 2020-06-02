import 'package:flutter/material.dart';

import 'earable/loadEarable.dart';
import 'home/home.dart';
import 'sphero/loadSphero.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      "/": (context) => Home(),
      "/loadEarable": (context) => LoadEarable(),
      "/loadSphero": (context) => LoadSphero(),
    },
  ));
}
