import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';

class ARMeasurePageAndroid extends StatefulWidget {
  @override
  _ARMeasurePageAndroidState createState() => _ARMeasurePageAndroidState();
}

class _ARMeasurePageAndroidState extends State<ARMeasurePageAndroid> {
  late ArCoreController arCoreController;

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    arCoreController.addArCoreNodeWithAnchor(ArCoreNode(
      shape: ArCoreSphere(
        materials: [ArCoreMaterial(color: Colors.red)],
        radius: 0.01,
      ),
      position: hit.pose.translation,
    ));
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AR Measurement - Android")),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }
}
