import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARMeasurePageIOS extends StatefulWidget {
  @override
  _ARMeasurePageIOSState createState() => _ARMeasurePageIOSState();
}

class _ARMeasurePageIOSState extends State<ARMeasurePageIOS> {
  late ARKitController arkitController;
  ARKitNode? startNode;
  ARKitNode? endNode;

  void _onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController.onNodeTap = (nodes) => _onSceneTapped;
  }

  void _onSceneTapped(ARKitNode? node) {
    if (startNode == null) {
      startNode = ARKitSphere(
        materials: [ARKitMaterial(diffuse: ARKitMaterialProperty.color(Colors.red))],
        radius: 0.01,
      ) as ARKitNode?;
      arkitController.add(startNode!);
    } else if (endNode == null) {
      endNode = ARKitSphere(
        materials: [ARKitMaterial(diffuse: ARKitMaterialProperty.color(Colors.blue))],
        radius: 0.01,
      ) as ARKitNode?;
      arkitController.add(endNode!);
      _calculateDistance();
    }
  }

  void _calculateDistance() {
    // Implement the distance calculation here
  }

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("AR Measurement - iOS")),
  //     body: ARKitSceneView(
  //       onARKitViewCreated: _onARKitViewCreated,
  //       configuration: ARKitConfiguration.imageTracking,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('ARKit in Flutter')),
      body: ARKitSceneView(onARKitViewCreated: onARKitViewCreated));

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    final node = ARKitNode(
        geometry: ARKitSphere(radius: 0.1), position: vector.Vector3(0, 0, -0.5));
    this.arkitController.add(node);
  }
}
