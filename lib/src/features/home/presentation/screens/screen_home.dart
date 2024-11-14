import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_code/main.dart';
import 'package:flutter_boilerplate_code/src/helpers/debugger_helper.dart';
import 'package:flutter_boilerplate_code/src/resources/app_colors.dart';
import 'package:flutter_boilerplate_code/src/resources/app_images.dart';
import 'package:flutter_boilerplate_code/src/routes/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  Future<bool> requestCameraPermission() async {
    // Request camera permission
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }

    if (!await Permission.camera.isGranted) {
      Fluttertoast.showToast(msg: "Please allow camera permissions.");
      openAppSettings();
      return false;
    }

    gCameras = await availableCameras();

    return true;
  }

  @override
  void initState() {
    requestCameraPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        toolbarHeight: 180,
        automaticallyImplyLeading: false,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              AppImages.appLogo,
              height: 32,
            ),
            Text(
              "Trawniczek",
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.primaryColorLight,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            IconButton(
              onPressed: () async {
                bool permission = await requestCameraPermission();
                Debugger.debug(
                  title: "ScreenHome.requestCameraPermission(): permission",
                  data: permission,
                );
                if (!permission) {
                  Fluttertoast.showToast(msg: "Please allow camera permissions");
                  openAppSettings();
                  return;
                }

                if(Platform.isIOS){
                  Navigator.pushNamed(context, Routes.arScreenIos);
                }else{
                  Navigator.pushNamed(context, Routes.arScreenAndroid);
                }

                //Navigator.pushNamed(context, Routes.cameraScreen);
              },
              icon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryColorLight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  AppImages.iconCameraFrameWithObject,
                  height: 48,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.secondaryColorLight,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                sliver: SliverList.separated(
                  itemCount: 20,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.objectDetailsScreen);
                      },
                      child: Card(
                        elevation: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.iconCameraFrameWithObject,
                                height: 50,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Unknow Object",
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    Text.rich(TextSpan(children: [
                                      const TextSpan(text: "Measurement (WxH): "),
                                      TextSpan(
                                        text: "126 (cm)",
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          color: AppColors.primaryColorLight,
                                        ),
                                      ),
                                      const TextSpan(text: " x "),
                                      TextSpan(
                                        text: "222 (cm)",
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          color: AppColors.primaryColorLight,
                                        ),
                                      ),
                                    ]))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(
                      height: 16,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
