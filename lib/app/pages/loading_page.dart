import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_services.dart';
import '../services/socket_service.dart';
import 'login_page.dart';
import 'users_page.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<void>(
        future: _checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Carregando...'),
           );
        }
      ),
   );

  }

  Future<void> _checkLoginState(BuildContext context) async {
    
    final isLoggedIn = await Provider.of<AuthService>(context).isLoggedIn();
    final socketService = Provider.of<SocketService>(context, listen: false);

    if ( isLoggedIn ) {

      socketService.connect();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:   ( _ , __ , ___ ) => const UsersPage(),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );

    } else {

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:   ( _ , __ , ___ ) => const LoginPage(),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );

    }
  }
}