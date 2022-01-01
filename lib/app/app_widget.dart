import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_services.dart';

import 'global/environment.dart';
import 'routes.dart';
import 'services/socket_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ( _ ) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: ( _ ) => SocketService(),
        ),
      ],
      builder: (context, snapshot) {
        return MaterialApp(
          scaffoldMessengerKey: Environment.msngrKey,
          debugShowCheckedModeBanner: false,
          title: 'Chat App',
          initialRoute: 'loading',
          // routes: appRoutes,
          onGenerateRoute: onGenerateRoutes,
        );
      }
    );
  }
}