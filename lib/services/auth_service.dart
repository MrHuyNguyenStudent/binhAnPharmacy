import 'dart:convert';
import 'package:binh_an_pharmacy/api/url_api.dart';
import 'package:binh_an_pharmacy/models/customer_model.dart';
import 'package:binh_an_pharmacy/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  final String registerUrl = '/account/RegisterCustomer';
  final String loginUrl = '/account/login';
  final UserService userService = UserService();
  //Hàm đăng ký tài khoản
  Future<bool> registerCustomer({
    required String username,
    required String emailAddress,
    required String matKhau,
    required String hoTen,
    required bool gioiTinh,
    required String ngaySinh,
    required String soDienThoai,
  }) async {
    final url = Uri.parse('${APIConfig.baseURL}$registerUrl');

    final Map<String, dynamic> body = {
      "username": username,
      "emailAddress": emailAddress,
      "matKhau": matKhau,
      "hoTen": hoTen,
      "diaChi": "string",
      "thanhPho": "string",
      "gioiTinh": gioiTinh,
      "ngaySinh": ngaySinh,
      "quyen": "CUSTOMER",
      "soDienThoai": soDienThoai,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Đăng ký tài khoản thành công!');
        return true;
      } else {
        print('Đăng ký thất bại: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi khi đăng ký tài khoản: $e');
      return false;
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${APIConfig.baseURL}$loginUrl?UserName=$username&Password=$password'),
        headers: {'accept': '*/*'},
      );
      if (response.statusCode == 200) {
        // Phân tích JSON và trả về accessToken và refreshToken
        final Map<String, dynamic> data = json.decode(response.body);
        final accessToken = data['accessToken'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token',accessToken);
        Customer customer= await UserService.getCustomerInfo();
        await saveCustomerIdToPreferences(customer.id);
      } else {
        throw Exception('Đăng nhập thất bại: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
  static Future<void> saveCustomerIdToPreferences(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('customerId', customerId);  // Lưu id khách hàng vào SharedPreferences
  }

}