import '../global/environment.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import '../models/users_response.dart';
import 'auth_services.dart';

class UsersService {
  
  Future<List<User>> getUsers() async {

    try {

      final resp = await http.get(
        Uri.parse('${Environment.apiURL}/users'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      final usersResponse = usersResponseFromJson(resp.body);
      return usersResponse.users!;

    } catch (e) {
      return [];
    }

  }

}