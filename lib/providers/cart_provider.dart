import 'package:binh_an_pharmacy/models/cart_item_model.dart';
import 'package:binh_an_pharmacy/screens/checkout_screen.dart';
import 'package:binh_an_pharmacy/services/cart_item_services.dart';
import 'package:binh_an_pharmacy/services/medicine_version_service.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  final CartItemServices _cartService = CartItemServices();
  final ApiProductVersionService _apiProductVersionService = ApiProductVersionService();
  List<CartItem> get cartItems => _cartItems;

  // Tải danh sách sản phẩm từ dịch vụ giỏ hàng
  Future<void> loadCartItems() async {
    try {
      _cartItems = await _cartService.fetchCartItems();
      notifyListeners();
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }
  // Tính tổng tiền cho các sản phẩm đã chọn
  double calculateTotalPrice() {
    return _cartItems
        .where((item) => item.selected)
        .fold(0.0, (sum, item) => sum + item.gia * item.soLuong);
  }

  // Thêm sản phẩm vào giỏ hàng
  void addItem(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  // Xóa tất cả sản phẩm được chọn khỏi giỏ hàng
  void clearSelectedItems() {
    _cartItems.removeWhere((item) => item.selected);
    notifyListeners();
  }
// Hàm xóa tất cả các sản phẩm đã chọn trong giỏ hàng
  Future<void> removeSelectedItems() async {
    // Lọc các sản phẩm đã chọn
    List<CartItem> selectedItems = cartItems.where((item) => item.selected).toList();

    // Lặp qua các sản phẩm đã chọn và xóa từng cái
    for (var item in selectedItems) {
      bool success = await CartItemServices().removeProductFromCart(item.phienBanSanPhamId);
      if (success) {
        // Xóa sản phẩm khỏi giỏ hàng sau khi xóa thành công
        cartItems.removeWhere((cartItem) => cartItem.phienBanSanPhamId == item.phienBanSanPhamId);
      }
    }

    // Thông báo cho UI về sự thay đổi
    notifyListeners();
  }
  // Cập nhật số lượng sản phẩm
  void updateItemQuantity(CartItem item, int newQuantity) {
    final index = _cartItems.indexOf(item);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(soLuong: newQuantity);
      notifyListeners();
    }
  }


  // Chuyển đổi trạng thái lựa chọn của một sản phẩm
  void toggleItemSelection(CartItem item, bool selected) {
    final index = _cartItems.indexOf(item);
    if (index != -1) {
      _cartItems[index].selected = selected;
      notifyListeners();
    }
  }

  // Chọn hoặc bỏ chọn tất cả sản phẩm
  void selectAllItems(bool selected) {
    for (var item in _cartItems) {
      item.selected = selected;
    }
    notifyListeners();
  }

  // Đếm số lượng sản phẩm đã được chọn
  int selectedItemsCount() {
    return _cartItems.where((item) => item.selected).length;
  }
  // Thêm hoặc cập nhật sản phẩm trong giỏ hàng
  void addOrUpdateItem(CartItem newItem) {
    // Tìm sản phẩm dựa trên `phienBanSanPhamId`
    final existingIndex = _cartItems.indexWhere(
            (item) => item.phienBanSanPhamId == newItem.phienBanSanPhamId);

    if (existingIndex != -1) {
      // Nếu sản phẩm đã tồn tại, cập nhật số lượng
      final existingItem = _cartItems[existingIndex];
      final updatedQuantity = existingItem.soLuong + newItem.soLuong;

      // Cập nhật sản phẩm với số lượng mới
      _cartItems[existingIndex] =
          existingItem.copyWith(soLuong: updatedQuantity);
    } else {
      // Nếu sản phẩm chưa có, thêm mới
      _cartItems.add(newItem);
    }

    notifyListeners(); // Thông báo để cập nhật giao diện
  }
// Phương thức để xóa sản phẩm khỏi giỏ hàng nếu cần
  void removeFromCart(String phienBanSanPhamId) {
    _cartItems.removeWhere((item) => item.phienBanSanPhamId == phienBanSanPhamId);
    notifyListeners();
  }
  // Hàm tính tổng khối lượng của các sản phẩm đã chọn
  Future<double> calculateSelectedItemsWeight() async {
    double totalWeight = 0.0;

    for (var item in _cartItems) {
      if (item.selected) {
        try {
          // Lấy thông tin phiên bản sản phẩm từ API
          final productVersion = await _apiProductVersionService.getProductVersion(item.phienBanSanPhamId);

          // Chuyển đổi khối lượng từ String sang double và cộng vào tổng
          final weight = double.tryParse(productVersion.khoiLuong) ?? 0.0;
          totalWeight += weight * item.soLuong;
        } catch (e) {
          print("Error fetching product version: $e");
        }
      }
    }
    return totalWeight/1000;
  }
  void toggleSelectedProduct(String phienBanSanPhamId) {
    // Lặp qua danh sách giỏ hàng và đánh dấu sản phẩm đã chọn
    for (var item in cartItems) {
      if (item.phienBanSanPhamId == phienBanSanPhamId) {
        item.selected = true;  // Đánh dấu là đã chọn
        notifyListeners();  // Cập nhật UI
        break;  // Dừng vòng lặp khi tìm thấy sản phẩm
      }
    }
  }
}