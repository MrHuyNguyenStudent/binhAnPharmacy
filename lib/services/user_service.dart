import 'dart:convert';
import 'package:binh_an_pharmacy/api/url_api.dart';
import 'package:binh_an_pharmacy/models/customer_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final String customerUrl='/khachhang/GetCurrentKhachHang?token=';

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');  // Trả về accessToken nếu có
  }
  // Hàm lưu id khách hàng vào SharedPreferences
  static Future<void> saveCustomerIdToPreferences(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('customerId', customerId);  // Lưu id khách hàng vào SharedPreferences
  }
  static Future<Customer> getCustomerInfo() async {
    String? token = await getAccessToken();  // Lấy accessToken từ SharedPreferences

    if (token == null) {
      throw Exception('Token không hợp lệ');
    }

    final response = await http.get(
      Uri.parse('${APIConfig.baseURL}$customerUrl$token'),
      headers: {
        'Authorization': 'Bearer $token',  // Gửi token trong header
      },
    );

    if (response.statusCode == 200) {
      Customer customer = Customer.fromJson(json.decode(response.body));

      await saveCustomerIdToPreferences(customer.id);

      return customer;
    } else {
      throw Exception('Lỗi lấy thông tin người dùng: ${response.reasonPhrase}');
    }
  }
}