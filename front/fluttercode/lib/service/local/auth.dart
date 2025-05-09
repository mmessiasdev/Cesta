// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class LocalAuthService {
//   final FlutterSecureStorage _storage = FlutterSecureStorage();

//   Future<void> storeToken(String token) async {
//     await _storage.write(key: "token", value: token);
//   }

//   Future<String?> getSecureToken() async {
//     return await _storage.read(key: "token");
//   }

//   // Armazenar os dados da conta
//   Future<void> storeAccount({
//     required String email,
//     required String fullname,
//     required int id,
//     required String cpf,
//   }) async {
//     await _storage.write(key: "id", value: id.toString());
//     await _storage.write(key: "email", value: email);
//     await _storage.write(key: "fullname", value: fullname);
//     await _storage.write(key: "username", value: cpf);
//   }

//   // Recuperar planId
//   Future<String?> getPlanId() async {
//     return await _storage.read(key: "planId");
//   }

//   // Recuperar email
//   Future<String?> getEmail() async {
//     return await _storage.read(key: "email");
//   }

//   // Recuperar ID
//   Future<String?> getProfileId() async {
//     return await _storage.read(key: "id");
//   }

//   // Recuperar fullname
//   Future<String?> getFullName() async {
//     return await _storage.read(key: "fullname");
//   }

//   Future<String?> getCpf() async {
//     return await _storage.read(key: "username");
//   }

//   Future<void> clear() async {
//     await _storage
//         .deleteAll(); // Limpa o armazenamento seguro em dispositivos móveis
//   }
// }

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // Importação específica para web

class LocalAuthService {
  // Verifica se está rodando na web
  bool get _isWeb => kIsWeb;

  // Usamos o FlutterSecureStorage apenas para mobile
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> storeToken(String token) async {
    if (_isWeb) {
      // Usa localStorage na web
      html.window.localStorage['token'] = token;
    } else {
      // Usa Secure Storage em dispositivos móveis
      await _storage.write(key: "token", value: token);
    }
  }

  Future<String?> getSecureToken() async {
    if (_isWeb) {
      return html.window.localStorage['token'];
    } else {
      return await _storage.read(key: "token");
    }
  }

  // Armazenar os dados da conta
  Future<void> storeAccount({
    required String email,
    required String fullname,
    required int id,
    required String cpf,
  }) async {
    if (_isWeb) {
      // Armazena como JSON na web
      html.window.localStorage['account'] = jsonEncode({
        'id': id.toString(),
        'email': email,
        'fullname': fullname,
        'username': cpf,
      });
    } else {
      // Armazena separadamente em mobile
      await _storage.write(key: "id", value: id.toString());
      await _storage.write(key: "email", value: email);
      await _storage.write(key: "fullname", value: fullname);
      await _storage.write(key: "username", value: cpf);
    }
  }

  // Recuperar planId
  Future<String?> getPlanId() async {
    if (_isWeb) {
      final account = html.window.localStorage['account'];
      return account != null ? jsonDecode(account)['planId'] : null;
    } else {
      return await _storage.read(key: "planId");
    }
  }

  // Recuperar email
  Future<String?> getEmail() async {
    if (_isWeb) {
      final account = html.window.localStorage['account'];
      return account != null ? jsonDecode(account)['email'] : null;
    } else {
      return await _storage.read(key: "email");
    }
  }

  // Recuperar ID
  Future<String?> getProfileId() async {
    if (_isWeb) {
      final account = html.window.localStorage['account'];
      return account != null ? jsonDecode(account)['id'] : null;
    } else {
      return await _storage.read(key: "id");
    }
  }

  // Recuperar fullname
  Future<String?> getFullName() async {
    if (_isWeb) {
      final account = html.window.localStorage['account'];
      return account != null ? jsonDecode(account)['fullname'] : null;
    } else {
      return await _storage.read(key: "fullname");
    }
  }

  Future<String?> getCpf() async {
    if (_isWeb) {
      final account = html.window.localStorage['account'];
      return account != null ? jsonDecode(account)['username'] : null;
    } else {
      return await _storage.read(key: "username");
    }
  }

  Future<void> clear() async {
    if (_isWeb) {
      // Limpa o localStorage na web
      html.window.localStorage.clear();
    } else {
      // Limpa o armazenamento seguro em dispositivos móveis
      await _storage.deleteAll();
    }
  }
}
