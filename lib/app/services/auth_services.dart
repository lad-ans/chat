import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../global/environment.dart';
import '../models/login_response.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

const tokenKey = 'token';

class AuthService with ChangeNotifier {
  
  User? user;
  bool _loading = false;

  final _storage = const FlutterSecureStorage();

  // token handler
  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    return (await _storage.read(key:  tokenKey))!;
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key:  tokenKey);
  }

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  } 

  Future login( String email, String password ) async {
    
    loading = true;

    final data = {
      'email': email,
      'password': password,
    };

    try {
      final resp = await http.post(
        Uri.parse('${Environment.apiURL}/login'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json'
        }
      );

      if ( resp.statusCode == 200 ) {
        final loginResp = loginResponseFromJson( resp.body );
        user = loginResp.user;

        await _saveToken(loginResp.token!);

        return true;

      } else {

        final data = jsonDecode(resp.body);
        return data['msg'];

      }

    } on http.ClientException catch ( e ) {

      return e.message;
    
    } catch (e) {
    
      return e;
    
    } finally {

      loading = false;
    
    }

  }

  Future register( String name, String email, String password ) async {
    
    loading = true;

    final data = {
      'name': name,
      'email': email,
      'password': password,
    };

    try {
      final resp = await http.post(
        Uri.parse('${Environment.apiURL}/login/new'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json'
        }
      );

      if ( resp.statusCode == 200 ) {
        final loginResp = loginResponseFromJson( resp.body );
        user = loginResp.user;

        await _saveToken(loginResp.token!);

        return true;

      } else {

        final data = jsonDecode(resp.body);
        return data['msg'];

      }

    } on http.ClientException catch ( e ) {

      return e.message;
    
    } catch (e) {
    
      return e;
    
    } finally {

      loading = false;
    
    }

  }

  Future<bool> isLoggedIn() async {

    final token = await _storage.read( key: tokenKey );

      try {
        final resp = await http.get(
          Uri.parse('${Environment.apiURL}/login/renew'),
           headers: {
            'Content-Type': 'application/json',
            'x-token': token ?? '',
          }
        );

        if ( resp.statusCode == 200 ) {
          final loginResp = loginResponseFromJson( resp.body );
          user = loginResp.user;

          if ( await _saveToken( loginResp.token! ) ) {
            return true;
          } else {
            return false;
          }


        } else {

          logout();
          return false;

        }

      } catch (e) { 

        e; 
        return false;
      
      }


  }



  Future<bool> _saveToken( String token ) async {
    try {

      await _storage.write( key: tokenKey, value: token );
      return true;

    } catch (e) {

      return false;

    }
  }

  Future<bool> logout() async {

    try {

      await _storage.delete( key: tokenKey );
      return true;

    } catch (e) {

      return false;
    
    }
    
  }

}