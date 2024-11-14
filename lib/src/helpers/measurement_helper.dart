import 'package:vector_math/vector_math_64.dart';

class MeasurementHelper{
  static double calculateDistance(Vector3 start, Vector3 end) {
    return start.distanceTo(end);
  }
}