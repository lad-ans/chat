import 'package:http/http.dart' as http;
import 'package:real_time_chat/app/global/environment.dart';
import 'package:real_time_chat/app/models/messages_response.dart';
import 'package:real_time_chat/app/services/auth_services.dart';

class ChatService {
  
  static Future<List<Message>> getChat ( String userID ) async {
    try {
      
      final resp = await http.get(
        Uri.parse('${Environment.apiURL}/messages/$userID'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      final messageResponse = messagesResponseFromJson(resp.body);
      return messageResponse.messages!;

    } catch (e) {
      return [];
    }
  }

}