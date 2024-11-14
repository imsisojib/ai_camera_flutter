import 'package:fluro/fluro.dart';
import 'package:flutter_boilerplate_code/src/features/ar/presentation/screens/ar_measure_page_android.dart';
import 'package:flutter_boilerplate_code/src/features/ar/presentation/screens/ar_measure_page_ios.dart';
import 'package:flutter_boilerplate_code/src/features/camera/presentation/screens/screen_camera.dart';
import 'package:flutter_boilerplate_code/src/features/errors/presentation/screens/screen_error.dart';
import 'package:flutter_boilerplate_code/src/features/home/presentation/screens/screen_details.dart';
import 'package:flutter_boilerplate_code/src/features/home/presentation/screens/screen_home.dart';
import 'package:flutter_boilerplate_code/src/routes/routes.dart';


class RouterHelper {
  static final FluroRouter router = FluroRouter();

  ///Handlers
  static final Handler _homeScreenHandler =
  Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    return const ScreenHome();
  });

  static final Handler _cameraScreenHandler =
  Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    return const ScreenCamera();
  });

  static final Handler _detailsScreenHandler =
  Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    return const ScreenDetails();
  });

  ///AR
  static final Handler _arScreenHandlerAndroid =
  Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    return ARMeasurePageAndroid();
  });
  static final Handler _arScreenHandlerIos =
  Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    return ARMeasurePageIOS();
  });


  static final Handler _notFoundHandler =
  Handler(handlerFunc: (context, parameters) => const ScreenError());

  void setupRouter() {
    router.notFoundHandler = _notFoundHandler;

    //main-nav flow
    router.define(Routes.homeScreen, handler: _homeScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.cameraScreen, handler: _cameraScreenHandler, transitionType: TransitionType.cupertino);
    router.define(Routes.objectDetailsScreen, handler: _detailsScreenHandler, transitionType: TransitionType.cupertino);

    ///AR
    router.define(Routes.arScreenAndroid, handler: _arScreenHandlerAndroid, transitionType: TransitionType.cupertino);
    router.define(Routes.arScreenIos, handler: _arScreenHandlerIos, transitionType: TransitionType.cupertino);
  }

}