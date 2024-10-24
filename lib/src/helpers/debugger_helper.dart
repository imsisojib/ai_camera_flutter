import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate_code/di_container.dart';
import 'package:logger/logger.dart';

class Debugger{
  static void debug({String? title, dynamic data, dynamic statusCode}){
    if(kDebugMode){
      //only show console messages in Debug-Mode
      if(statusCode==null){
        sl<Logger>().i("Title: $title\nResult: $data",);
      }else{
        sl<Logger>().i("Title: $title\nResponse-Code: $statusCode\nResult: $data",);
      }
    }
  }

  static void info({String? title, dynamic data, dynamic statusCode}){
    if(kDebugMode){
      //only show console messages in Debug-Mode
      if(statusCode==null){
        sl<Logger>().i("Title: $title\nResult: $data",);
      }else{
        sl<Logger>().i("Title: $title\nResponse-Code: $statusCode\nResult: $data",);
      }
    }
  }

  static void error({String? title, dynamic data, dynamic statusCode}){
    if(kDebugMode){
      //only show console messages in Debug-Mode
      if(statusCode==null){
        sl<Logger>().i("Title: $title\nResult: $data",);
      }else{
        sl<Logger>().i("Title: $title\nResponse-Code: $statusCode\nResult: $data",);
      }
    }
  }
}