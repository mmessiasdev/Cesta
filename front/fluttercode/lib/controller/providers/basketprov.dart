// import 'package:Cesta/model/basket.dart';
// import 'package:flutter/foundation.dart';
// import 'package:Cesta/service/remote/baskets/crud.dart';

// class BasketProvider with ChangeNotifier {
//   List<Basket> _baskets = [];
//   bool _isLoading = false;
//   String? _error;

//   List<Basket> get baskets => _baskets;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   final BasketService _basketService;

//   BasketProvider({required String token}) 
//       : _basketService = BasketService(token: token);

//   Future<void> loadBaskets() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       _baskets = await _basketService.getBaskets();
//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//       if (kDebugMode) {
//         print('Error loading baskets: $_error');
//       }
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> addBasket({
//     required int studentId,
//     required List<XFile> comprovantImages,
//     required int profileId,
//   }) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       final response = await _basketService.addBasket(
//         studentId: studentId,
//         comprovantImages: comprovantImages,
//         profileId: profileId,
//       );

//       if (response.statusCode == 200) {
//         await loadBaskets(); // Refresh the list
//         return true;
//       } else {
//         _error = 'Server error: ${response.body}';
//         return false;
//       }
//     } catch (e) {
//       _error = e.toString();
//       if (kDebugMode) {
//         print('Error adding basket: $_error');
//       }
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshBaskets() async {
//     await loadBaskets();
//   }
// }