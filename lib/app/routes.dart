import 'package:flutter/material.dart';

import 'models/user.dart';
import 'pages/chat_page.dart';
import 'pages/loading_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/users_page.dart';

final Map<String, Widget Function(BuildContext, Object?)> appRoutes = {

  'users': ( _ , args ) => const UsersPage(),
  'chat'    : ( _ , args ) => ChatPage( user: (args as User), ),
  'login'   : ( _ , args ) => const LoginPage(),
  'register': ( _ , args ) => const RegisterPage(),
  'loading' : ( _ , args ) => const LoadingPage(),

};

Route<dynamic> onGenerateRoutes( RouteSettings settings ) {
  var navigateTo = appRoutes[settings.name];

  return PageRouteBuilder(pageBuilder: ( context, __, ___ ) {
    return navigateTo!( context, settings.arguments );
  });

}


