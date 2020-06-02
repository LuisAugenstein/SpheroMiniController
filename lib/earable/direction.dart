import 'dart:math';

class Direction {
  List<int> _headAccel = [0, 0, 0]; //3D Vector
  List<double> _spheroDirection = [0, 0]; //2D Vector
  static int _maxValue = 1000;
  static List<double> _offset = [0, 0];
  static int _aim = 0;

  Direction(this._headAccel) {
    //int max = _headAccel.reduce((value, element) => value > element ? value : element);
    //_maxValue = max > _maxValue ? max : _maxValue;
    _spheroDirection[0] = (_headAccel[2] / _maxValue).floor().toDouble();
    _spheroDirection[1] = (_headAccel[1] / _maxValue).floor().toDouble();
  }

  getDirection() {
    return [_spheroDirection[0] - _offset[0], _spheroDirection[1] - _offset[1]];
  }

  // get RotationAngle from 0 to 360;
  int getAngleDegree() {
    List<double> x = getDirection();
    int angle = (atan2(x[0], x[1]) * 180 / pi).floor();
    angle = angle < 0 ? angle + 360 : angle;
    return angle;
  }

  // returns angle from -pi to pi
  double getAngleRadian() {
    List<double> x = getDirection();
    return atan2(x[0], x[1]);
  }

  int getIntensityInt() {
    List<double> x = getDirection();
    double intensity = sqrt(x[0] * x[0] + x[1] * x[1]) * 35;
    return (intensity > 255 ? 255 : intensity).floor();
  }

  double getIntensityDouble() {
    List<double> x = getDirection();
    return sqrt(x[0] * x[0] + x[1] * x[1]) / 10;
  }

  updateOffset() {
    _offset = _spheroDirection;
  }

  updateAim() {
    _aim = getAngleDegree();
  }

  int getAimDegree() {
    return _aim;
  }

  String toString() {
    List<double> x = getDirection();
    return "vector: (${x[0].floor()},${x[1].floor()}), angle: ${getAngleDegree()}, intensity: ${getIntensityInt()}";
  }
}
