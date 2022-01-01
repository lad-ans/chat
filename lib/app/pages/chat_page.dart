import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/app/services/auth_services.dart';
import 'package:real_time_chat/app/services/chat_service.dart';
import 'package:real_time_chat/app/services/socket_service.dart';
import '../models/user.dart';

import '../widgets/chat_message.dart';


class ChatPage extends StatefulWidget {

  final User? user;

  const ChatPage({ Key? key, this.user }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  final List<ChatMessage> _messages = [];

  bool _istyping = false;
  SocketService? _socketService;
  AuthService? _authService;

  @override
  void initState() {
    super.initState();
    _socketService = Provider.of<SocketService>(context, listen: false);
    _authService = Provider.of<AuthService>(context, listen: false);

    _socketService!.socket.on('personal-message', _listenToMessage);

    _loadHistory(widget.user!.uid!);
  }

  void _loadHistory( String userID ) async {

    final chat = await ChatService.getChat( userID );

    final history = chat.map((e) => ChatMessage(
      text: e.message, 
      uid: e.from, 
      animationController: AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400),
      )..forward()
    ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenToMessage( dynamic payload ) {
    ChatMessage message = ChatMessage(
      text: payload['message'],
      uid: payload['from'],
      animationController: AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400)
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(widget.user!.name!.substring(0, 2), style: const TextStyle(fontSize: 12) ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            const SizedBox( height: 3 ),
            Text(widget.user!.name!, style: const TextStyle( color: Colors.black87, fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),

      body: Column(
        children: <Widget>[
          
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            ),
          ),

          const Divider( height: 1 ),

          Container(
            color: Colors.white,
            child: _inputChat(),
          ),
        ],
      ),
   );
  }

  Widget _inputChat() {

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 8.0 ),
        child: Row(
          children: <Widget>[

            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit ,
                onChanged: ( texto ){
                  setState(() {
                    if ( texto.trim().isNotEmpty ) {
                      _istyping = true;
                    } else {
                      _istyping = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensagem'
                ),
                focusNode: _focusNode,
              )
            ),

            // Botón de enviar
            Container(
              margin: const EdgeInsets.symmetric( horizontal: 4.0 ),
              child: Platform.isIOS 
              ? CupertinoButton(
                child: const Text('Enviar'), 
                onPressed: _istyping 
                  ? () => _handleSubmit( _textController.text.trim() )
                  : null,
              )
              
              : Container(
                margin: const EdgeInsets.symmetric( horizontal: 4.0 ),
                child: IconTheme(
                  data: IconThemeData( color: Colors.blue[400] ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon( Icons.send ),
                    onPressed: _istyping 
                      ? () => _handleSubmit( _textController.text.trim() )
                      : null,
                  ),
                ),
              ),
            )

          ],
        ),
      )
    );

  }


  _handleSubmit(String text ) {

    if ( text.isEmpty ) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: _authService!.user!.uid, 
      text: text,
      animationController: AnimationController(vsync: this, duration: const Duration( milliseconds: 200 )),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController?.forward();

    setState(() { _istyping = false; });

    _socketService!.socket.emit('personal-message', {
      'from': _authService!.user!.uid,
      'to': widget.user!.uid,
      'message': text,
    });
  }

  @override
  void dispose() {

    for( ChatMessage message in _messages ) {
      message.animationController?.dispose();
    }

    // clossing broadcast oon leave message page to avoid dat costs
    _socketService?.socket.off('personal-message');

    super.dispose();
  }

}