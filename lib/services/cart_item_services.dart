import 'dart:convert';
import 'package:binh_an_pharmacy/api/url_api.dart';
import 'package:binh_an_pharmacy/models/cart_item_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartItemServices {
  final getCartItemUrl="/giohang/GetGioHangByToken";
  final addProductUrl = "/giohang/ThemSanPhamVaoGioHang";
  final removeProductUrl = '/giohang/XoaSanPhamKhoiGioHang';
  final increaseProductQuantityUrl= '/giohang/TangSoLuong';
  final decreaseProductQuantityUrl= '/giohang/GiamSoLuong';

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');  // Trả về accessToken nếu có
  }
  // Hàm lưu id khách hàng vào SharedPreferences
  static Future<void> saveCustomerIdToPreferences(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('customerId', customerId);  // Lưu id khách hàng vào SharedPreferences
  }
  Future<List<CartItem>> fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Access token not found');
    }
    final url = Uri.parse('${APIConfig.baseURL}$getCartItemUrl');
    final response = await http.get(
      url,
      headers: {
        'accept': '*/*',
        'token': token,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CartItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cart items');
    }

  }
// Phương thức thêm sản phẩm vào giỏ hàng
  Future<bool> addProductToCart({
    required String khachHangId,
    required String phienBanSanPhamId,
    required int soLuong,
  }) async {
    // Lấy token từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Access token not found');
    }

    // URL API
    final url = Uri.parse('${APIConfig.baseURL}$addProductUrl');

    // Tạo body yêu cầu
    final Map<String, dynamic> body = {
      "khachHangId": khachHangId,
      "phienBanSanPhamId": phienBanSanPhamId,
      "soLuong": soLuong,
    };

    // Gửi yêu cầu POST
    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'token': token,
      },
      body: json.encode(body),
    );

    // Xử lý phản hồi
    if (response.statusCode == 200) {
      print('Thêm sản phẩm vào giỏ hàng thành công!');
      return true;
    } else {
      print('Thêm sản phẩm vào giỏ hàng thất bại: ${response.body}');
      throw Exception('Failed to add product to cart');
    }
  }
  Future<void> removeSelectedProducts(List<CartItem> cartItems) async {
    // Lọc các sản phẩm đã chọn
    List<CartItem> selectedItems = cartItems.where((item) => item.selected).toList();

    for (var item in selectedItems) {
      // Gọi hàm removeProductFromCart để xóa sản phẩm
      bool success = await removeProductFromCart(item.phienBanSanPhamId);

      if (success) {
        // Xóa sản phẩm khỏi giỏ hàng nếu thành công
        cartItems.removeWhere((cartItem) => cartItem.phienBanSanPhamId == item.phienBanSanPhamId);
      }
    }
  }
  // xóa 1 sản phẩm khỏi giỏ hàng
  Future<bool> removeProductFromCart(String productVersionId) async {
    // Lấy token từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Access token not found');
    }
    final url = Uri.parse('${APIConfig.baseURL}$removeProductUrl');
    try {
      final response = await http.delete(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'token': token, // Thêm token để xác thực
        },
        body: json.encode(productVersionId),
      );

      if (response.statusCode == 200) {
        return true; // Xóa thành công
      } else {
        print('Failed to delete product: ${response.statusCode}, ${response.body}');
        return false; // Xóa thất bại
      }
    } catch (error) {
      print('Error during delete: $error');
      return false; // Có lỗi trong quá trình thực hiện
    }
  }
  // tăng số lượng sản phẩm lên 1 đơn vị trong giỏ hàng
  Future<bool> increaseProductQuantity(String productVersionId) async {
    // Lấy token từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Access token not found');
    }
    final url = Uri.parse('${APIConfig.baseURL}$increaseProductQuantityUrl');
    try {
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'token': token, // Thêm token để xác thực
        },
        body: json.encode(productVersionId),
      );

      if (response.statusCode == 200) {
        return true; // Xóa thành công
      } else {
        print('Failed to delete product: ${response.statusCode}, ${response.body}');
        return false; // Xóa thất bại
      }
    } catch (error) {
      print('Error during delete: $error');
      return false; // Có lỗi trong quá trình thực hiện
    }
  }
  // giảm số lượng sản phẩm xuống 1 đơn vị trong giỏ hàng
  Future<bool> decreaseProductQuantity(String productVersionId) async {
    // Lấy token từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Access token not found');
    }
    final url = Uri.parse('${APIConfig.baseURL}$decreaseProductQuantityUrl');
    try {
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'token': token, // Thêm token để xác thực
        },
        body: json.encode(productVersionId),
      );

      if (response.statusCode == 200) {
        return true; // Xóa thành công
      } else {
        print('Failed to delete product: ${response.statusCode}, ${response.body}');
        return false; // Xóa thất bại
      }
    } catch (error) {
      print('Error during delete: $error');
      return false; // Có lỗi trong quá trình thực hiện
    }
  }
  // Hàm kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
  Future<bool> isProductInCart(String phienBanSanPhamId) async {
    try {
      // Lấy danh sách sản phẩm trong giỏ hàng
      List<CartItem> cartItems = await fetchCartItems();

      // Kiểm tra nếu sản phẩm đã có trong giỏ hàng
      for (var item in cartItems) {
        if (item.phienBanSanPhamId == phienBanSanPhamId) {
          return true; // Sản phẩm đã có trong giỏ hàng
        }
      }
      return false; // Sản phẩm chưa có trong giỏ hàng
    } catch (error) {
      print('Error checking if product is in cart: $error');
      return false;
    }
  }
  // Hàm cập nhật số lượng sản phẩm trong giỏ hàng
  Future<bool> updateProductQuantity({
    required String khachHangId,
    required String phienBanSanPhamId,
    required int newQuantity,
  }) async {
    try {
      // Kiểm tra xem sản phẩm có trong giỏ hàng không
      bool productExists = await isProductInCart(phienBanSanPhamId);

      if (productExists) {
        // Nếu sản phẩm có trong giỏ hàng, lấy danh sách sản phẩm
        List<CartItem> cartItems = await fetchCartItems();

        // Tìm sản phẩm và lấy số lượng của nó
        for (var item in cartItems) {
          if (item.phienBanSanPhamId == phienBanSanPhamId) {
            newQuantity = item.soLuong+newQuantity;  // Lấy số lượng hiện tại của sản phẩm
            break;
          }
        }

        // Xóa sản phẩm cũ khỏi giỏ hàng
        bool removed = await removeProductFromCart(phienBanSanPhamId);
        if (!removed) {
          print('Không thể xóa sản phẩm khỏi giỏ hàng');
          return false; // Không thể xóa sản phẩm
        }

        // Thêm sản phẩm lại với số lượng mới
        bool added = await addProductToCart(
          khachHangId: khachHangId,
          phienBanSanPhamId: phienBanSanPhamId,
          soLuong: newQuantity,
        );

        return added; // Trả về kết quả sau khi thêm sản phẩm mới vào giỏ hàng
      } else {
        // Nếu sản phẩm chưa có trong giỏ hàng, thêm mới sản phẩm
        bool added = await addProductToCart(
          khachHangId: khachHangId,
          phienBanSanPhamId: phienBanSanPhamId,
          soLuong: newQuantity,
        );
        return added;
      }
    } catch (error) {
      print('Error updating product quantity: $error');
      return false;
    }
  }
}