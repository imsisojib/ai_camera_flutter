import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_code/main.dart';
import 'package:flutter_boilerplate_code/src/config/custom_typedefs.dart';
import 'package:flutter_boilerplate_code/src/core/presentation/widgets/loading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../resources/app_colors.dart';

class ScreenCamera extends StatefulWidget {
  final OnCapturedPhoto? onCapturedPhoto;

  const ScreenCamera({
    super.key,
    this.onCapturedPhoto,
  });

  @override
  State<ScreenCamera> createState() => _ScreenCameraState();
}

class _ScreenCameraState extends State<ScreenCamera> with TickerProviderStateMixin {
  CameraController? cameraController;

  File? _selectedFile;

  //zoom level
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  //default FlashMode
  FlashMode _activeFlashMode = FlashMode.off;
  bool _openFlashToggle = false;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  void _takePicture() async {
    try {
      XFile? file = await cameraController?.takePicture();
      if (file != null) {
        _selectedFile = File(file.path);
        setState(() {});
      }
      //close the page
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to capture photo.");
    }
  }

  Future<void> _initializeCamera(CameraDescription description) async {
    cameraController = CameraController(
      description,
      ResolutionPreset.medium,
    );
    cameraController?.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      cameraController?.setFlashMode(FlashMode.auto);

      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        cameraController!.getMaxZoomLevel().then((double value) => _maxAvailableZoom = value),
        cameraController!.getMinZoomLevel().then((double value) => _minAvailableZoom = value),
      ]);

      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (cameraController == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale).clamp(_minAvailableZoom, _maxAvailableZoom);

    await cameraController!.setZoomLevel(_currentScale);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (cameraController == null) {
      return;
    }

    final CameraController controller = cameraController!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller.setExposurePoint(offset);
    controller.setFocusPoint(offset);
  }

  IconData findFlashIconData(FlashMode mode) {
    switch (mode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.highlight;
      default:
        return Icons.flash_off;
    }
  }

  Widget _flashModeControlRowWidget() {
    return Row(
      children: [
        _openFlashToggle
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.flash_off),
                    color: _activeFlashMode == FlashMode.off ? Colors.orange : Colors.white70,
                    onPressed: cameraController != null ? () => setFlashMode(FlashMode.off) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.flash_auto),
                    color: _activeFlashMode == FlashMode.auto ? Colors.orange : Colors.white70,
                    onPressed: cameraController != null ? () => setFlashMode(FlashMode.auto) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.flash_on),
                    color: _activeFlashMode == FlashMode.always ? Colors.orange : Colors.white70,
                    onPressed: cameraController != null ? () => setFlashMode(FlashMode.always) : null,
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.highlight),
                  //   color: cameraController?.value.flashMode == FlashMode.torch ? Colors.orange : Colors.white70,
                  //   onPressed: cameraController != null ? () => setFlashMode(FlashMode.torch) : null,
                  // ),
                ],
              )
            : IconButton(
                icon: Icon(findFlashIconData(_activeFlashMode)),
                color: (_activeFlashMode==FlashMode.always || _activeFlashMode==FlashMode.auto) ? Colors.orange: Colors.white70,
                onPressed: cameraController != null ? onFlashModeButtonPressed : null,
              )
      ],
    );
  }

  void onFlashModeButtonPressed() {
    setState(() {
      _openFlashToggle = !_openFlashToggle;
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (cameraController == null) {
      return;
    }

    try {
      await cameraController!.setFlashMode(mode);

      setState(() {
        _activeFlashMode = mode;
        _openFlashToggle = false;
      });
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {

    if (gCameras.isNotEmpty) _initializeCamera(gCameras.first);
    super.initState();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: !(cameraController?.value.isInitialized ?? false)
              ? const Loading()
              : Column(
                  children: [
                    Expanded(
                      child: Stack(
                        //fit: StackFit.expand,
                        children: <Widget>[
                          _selectedFile == null
                              ? Stack(
                                  children: [
                                    Listener(
                                      onPointerDown: (_) => _pointers++,
                                      onPointerUp: (_) => _pointers--,
                                      child: CameraPreview(
                                        cameraController!,
                                        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                                          return GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onScaleStart: _handleScaleStart,
                                            onScaleUpdate: _handleScaleUpdate,
                                            onTap: (){
                                              setState(() {
                                                _openFlashToggle = false;
                                              });
                                            },
                                            onTapDown: (TapDownDetails details) => onViewFinderTap(details, constraints),
                                          );
                                        }),
                                      ),
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: _flashModeControlRowWidget(),
                                    ),
                                  ],
                                )
                              : Image.file(
                                  _selectedFile!,
                                  height: cameraController!.value.aspectRatio * MediaQuery.of(context).size.width,
                                  width: MediaQuery.of(context).size.width,
                                ),
                          // Align(
                          //   alignment: Alignment.bottomCenter,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(bottom: 24.0),
                          //     child: FloatingActionButton(
                          //       onPressed: () {
                          //         _takePicture(); // Call method to take picture
                          //       },
                          //       backgroundColor: Colors.white,
                          //       foregroundColor: AppColors.primaryColorLight,
                          //       child: const Icon(Icons.camera),
                          //     ),
                          //   ),
                          // ),

                          // Align(
                          //   alignment: Alignment.bottomCenter,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(bottom: 24.0),
                          //     child: _selectedFile == null
                          //         ? InkWell(
                          //             onTap: () {
                          //               _takePicture(); // Call method to take picture
                          //             },
                          //             child: Container(
                          //               decoration: BoxDecoration(
                          //                 color: Colors.black.withOpacity(.3),
                          //                 border: Border.all(
                          //                   color: Colors.white,
                          //                   width: 3,
                          //                 ),
                          //                 shape: BoxShape.circle,
                          //               ),
                          //               padding: EdgeInsets.all(3),
                          //               child: Container(
                          //                 height: 48.h,
                          //                 width: 48.h,
                          //                 decoration: BoxDecoration(
                          //                   shape: BoxShape.circle,
                          //                   color: Colors.white,
                          //                 ),
                          //               ),
                          //             ),
                          //           )
                          //         : FloatingActionButton(
                          //             elevation: 0,
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(200),
                          //             ),
                          //             onPressed: () {
                          //               Navigator.pop(context); // Call method to take picture
                          //               widget.onCapturedPhoto.call(_selectedFile!);
                          //             },
                          //             backgroundColor: AppColors.black.withOpacity(.3),
                          //             foregroundColor: AppColors.green,
                          //             child: const Icon(Icons.done),
                          //           ),
                          //   ),
                          // ),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                bottom: 24.0,
                                left: 16.0,
                                right: 32.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (_selectedFile == null) {
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      _selectedFile = null;
                                    });
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.black.withOpacity(.3),
                                  radius: 20,
                                  child: const Icon(
                                    Icons.clear,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 90.h,
                      //height: MediaQuery.of(context).size.height/controller.value.aspectRatio,
                      width: MediaQuery.of(context).size.width,
                      // decoration: BoxDecoration(
                      //   color: Colors.black,
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: _selectedFile == null
                            ? Center(
                                child: InkWell(
                                  onTap: () {
                                    _takePicture(); // Call method to take picture
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.3),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      height: 48.h,
                                      width: 48.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: FloatingActionButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context); // Call method to take picture
                                    widget.onCapturedPhoto?.call(_selectedFile!);
                                  },
                                  backgroundColor: AppColors.black.withOpacity(.3),
                                  foregroundColor: AppColors.green,
                                  child: const Icon(
                                    Icons.done,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    )
                  ],
                )),
    );
  }
}
