import 'dart:io';

import 'package:flutter/material.dart';

class Environment {
  // static String apiURL = Platform.isAndroid 
  //   ? 'http://10.0.2.2:3000/api'
  //   : 'http://192.168.1.101:3000/api'; 

  // static String socketURL = Platform.isAndroid 
  //   ? 'http://10.0.2.2:3000'
  //   : 'http://192.168.1.101:3000'; 

  static String apiURL = 'https://flutter-chat-backend-server.herokuapp.com/api';
  static String socketURL = 'https://flutter-chat-backend-server.herokuapp.com';

  
  static final  msngrKey = GlobalKey<ScaffoldMessengerState>();
}