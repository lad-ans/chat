import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../global/environment.dart';
import '../helpers/helpers.dart';
import '../models/user.dart';
import '../services/auth_services.dart';
import '../services/socket_service.dart';
import '../services/users_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final usersService = UsersService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(authService.user!.name!, style: const TextStyle(color: Colors.black87 ) ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app, color: Colors.black87 ),
          onPressed: () async {

            if ( await authService.logout() ) {
              
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');

            } else {
              
              Environment.msngrKey.currentState!.showMaterialBanner(
                customMaterialBanner(
                  'Erro ao fazer o logout! Vonte a tentar!!!', 
                  onPressed: () => Environment.msngrKey.currentState?.hideCurrentMaterialBanner(),
                )
              );

            }
          },
        ),  
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only( right: 10 ),
            child: socketService.serverStatus == ServerStatus.online 
              ? Icon( Icons.check_circle, color: Colors.blue[400] )
              : const Icon( Icons.offline_bolt, color: Colors.red ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue[400]!,
        ),
        child: _listViewUsers(),
      )
   );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile( _users[i] ), 
      separatorBuilder: (_, i) => const Divider(), 
      itemCount: _users.length
    );
  }

  ListTile _userListTile( User user ) {
    return ListTile(
        onTap: () => Navigator.of(context).pushNamed('chat', arguments: user),
        title: Text( user.name! ),
        subtitle: Text( user.email! ),
        leading: CircleAvatar(
          child: Text( user.name!.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online! ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }


  _loadUsers() async { 

    _users = await usersService.getUsers();
    setState(() {});
    _refreshController.refreshCompleted();

  }
}