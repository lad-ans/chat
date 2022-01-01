import 'package:flutter/material.dart';
import '../global/environment.dart';
import 'auth_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as _io;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  online, offline, connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;

  ServerStatus get serverStatus => _serverStatus;

  _io.Socket? _socket;

  _io.Socket get socket => _socket!;

  void connect() async {

    final token = await AuthService.getToken();
    
    try {

      _socket = _io.io(
        Environment.socketURL,
        OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setExtraHeaders({
            'x-token': token
          })
          .enableAutoConnect()
          .build()
        );

      _socket!.onConnect((_) {
        _serverStatus = ServerStatus.online;
        notifyListeners();
      });

      _socket!.onDisconnect((_) {
        _serverStatus = ServerStatus.offline;
        notifyListeners();
      });

    } catch (e) {
      e;
    }
  
  }

  void disconnect() {
    _socket?.disconnect();
  }

}