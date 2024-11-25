import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'dart:math';

class ARMeasureView extends StatefulWidget {
  const ARMeasureView({super.key});

  @override
  _ARMeasureViewState createState() => _ARMeasureViewState();
}

class _ARMeasureViewState extends State<ARMeasureView> {
  late ArCoreController arCoreController;
  List<v.Vector3> points = [];

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    arCoreController.onPlaneTap = (List<ArCoreHitTestResult> hits) {
      if (hits.isNotEmpty) {
        final hit = hits.first;
        _addPoint(hit.pose.translation);
      }
    };
  }

  void _addPoint(v.Vector3 point) {
    if (points.length < 2) {
      setState(() {
        points.add(point);
        if (points.length == 2) {
          _measureDistance();
        }
      });

      arCoreController.addArCoreNode(ArCoreNode(
        shape: ArCoreSphere(
          materials: [ArCoreMaterial(color: Colors.red)],
          radius: 0.02,
        ),
        position: point,
      ));
    }
  }

  void _measureDistance() {
    if (points.length == 2) {
      final distance = _calculateDistance(points[0], points[1]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Distance: ${distance.toStringAsFixed(2)} meters')),
      );
    }
  }

  double _calculateDistance(v.Vector3 p1, v.Vector3 p2) {
    final dx = p1.x - p2.x;
    final dy = p1.y - p2.y;
    final dz = p1.z - p2.z;
    return sqrt(dx * dx + dy * dy + dz * dz);
  }

  @override
  Widget build(BuildContext context) {
    return ArCoreView(
      onArCoreViewCreated: _onArCoreViewCreated,
      enablePlaneRenderer: true,
    );
  }
}