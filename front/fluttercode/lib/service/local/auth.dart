import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalAuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> storeToken(String token) async {
    await _storage.write(key: "token", value: token);
  }

  Future<String?> getSecureToken() async {
    return await _storage.read(key: "token");
  }

  // Armazenar os dados da conta
  Future<void> storeAccount({
    required String email,
    required String fullname,
    required int id,
    required String cpf,
  }) async {
    await _storage.write(key: "id", value: id.toString());
    await _storage.write(key: "email", value: email);
    await _storage.write(key: "fullname", value: fullname);
    await _storage.write(key: "username", value: cpf);
  }

  // Recuperar planId
  Future<String?> getPlanId() async {
    return await _storage.read(key: "planId");
  }

  // Recuperar email
  Future<String?> getEmail() async {
    return await _storage.read(key: "email");
  }

  // Recuperar ID
  Future<String?> getProfileId() async {
    return await _storage.read(key: "id");
  }

  // Recuperar fullname
  Future<String?> getFullName() async {
    return await _storage.read(key: "fullname");
  }

  Future<String?> getCpf() async {
    return await _storage.read(key: "username");
  }

  Future<void> clear() async {
    await _storage
        .deleteAll(); // Limpa o armazenamento seguro em dispositivos móveis
  }
}

// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:html' as html;

// class LocalAuthService {
//   bool _isWeb() {
//     try {
//       return identical(0, 0.0); // Verificação para Web
//     } catch (e) {
//       return false;
//     }
//   }

//   final FlutterSecureStorage _storage = FlutterSecureStorage();

//   Future<void> storeToken(String token) async {
//     if (_isWeb()) {
//       html.window.localStorage['token'] = token;
//     } else {
//       await _storage.write(key: "token", value: token);
//     }
//   }

//   Future<String?> getSecureToken() async {
//     if (_isWeb()) {
//       return html.window.localStorage['token'];
//     } else {
//       return await _storage.read(key: "token");
//     }
//   }

//   // Armazenar os dados da conta
//   Future<void> storeAccount({
//     required String email,
//     required String fullname,
//     required int id,
//     required String cpf,
//     required int planId,
//   }) async {
//     if (_isWeb()) {
//       html.window.localStorage['account'] = jsonEncode({
//         "id": id.toString(),
//         "email": email,
//         "fullname": fullname,
//         "cpf": cpf,
//         "planId": planId.toString(),
//       });
//     } else {
//       await _storage.write(key: "id", value: id.toString());
//       await _storage.write(key: "email", value: email);
//       await _storage.write(key: "fullname", value: fullname);
//       await _storage.write(key: "username", value: cpf);
//       await _storage.write(key: "planId", value: planId.toString());
//     }
//   }

//   // Recuperar planId
//   Future<String?> getPlanId() async {
//     if (_isWeb()) {
//       final account = html.window.localStorage['account'];
//       if (account != null) {
//         return jsonDecode(account)['planId'];
//       }
//       return null;
//     } else {
//       return await _storage.read(key: "planId");
//     }
//   }

//   // Recuperar email
//   Future<String?> getEmail() async {
//     if (_isWeb()) {
//       final account = html.window.localStorage['account'];
//       if (account != null) {
//         return jsonDecode(account)['email'];
//       }
//       return null;
//     } else {
//       return await _storage.read(key: "email");
//     }
//   }

//   // Recuperar ID
//   Future<String?> getId() async {
//     if (_isWeb()) {
//       final account = html.window.localStorage['account'];
//       if (account != null) {
//         return jsonDecode(account)['id'];
//       }
//       return null;
//     } else {
//       return await _storage.read(key: "id");
//     }
//   }

//   // Recuperar fullname
//   Future<String?> getFullName() async {
//     if (_isWeb()) {
//       final account = html.window.localStorage['account'];
//       if (account != null) {
//         return jsonDecode(account)['fullname'];
//       }
//       return null;
//     } else {
//       return await _storage.read(key: "fullname");
//     }
//   }

//   Future<String?> getCpf() async {
//     if (_isWeb()) {
//       final account = html.window.localStorage['account'];
//       if (account != null) {
//         return jsonDecode(account)['cpf'];
//       }
//       return null;
//     } else {
//       return await _storage.read(key: "username");
//     }
//   }

//   Future<void> clear() async {
//     if (_isWeb()) {
//       html.window.localStorage.clear();
//     } else {
//       await _storage.deleteAll();
//     }
//   }
// }
