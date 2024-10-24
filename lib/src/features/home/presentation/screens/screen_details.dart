import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_code/src/resources/app_colors.dart';
import 'package:flutter_boilerplate_code/src/resources/app_images.dart';
import 'package:flutter_boilerplate_code/src/routes/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenDetails extends StatefulWidget {
  const ScreenDetails({super.key});

  @override
  State<ScreenDetails> createState() => _ScreenDetailsState();
}

class _ScreenDetailsState extends State<ScreenDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColorLight,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Details",
          style: theme.textTheme.titleLarge,
        ),
        titleSpacing: 4,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                AppImages.placeholderMeasurement,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
