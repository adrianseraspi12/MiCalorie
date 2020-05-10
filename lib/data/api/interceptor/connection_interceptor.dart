import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:connectivity/connectivity.dart';

class ConnectionInterceptor implements RequestInterceptor {
 
  @override
  FutureOr<Request> onRequest(Request request) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      throw NoInternetConnectionException();
    }

    return request;
  }

}

class NoInternetConnectionException implements Exception {

  final message = 'No internet connection.\nPlease connect to a stable internet';

  @override
  String toString() => message;

}