import 'dart:convert';
import 'package:binh_an_pharmacy/api/url_api.dart';
import 'package:binh_an_pharmacy/api/url_giaohangtietkiem_api.dart';
import 'package:binh_an_pharmacy/models/address_model.dart';
import 'package:binh_an_pharmacy/models/local_address_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DiaChiKhachHangService {
  final addressUrl = '/diachikhachhang/LayDanhSachDiaChiKhachHang?khachHangId=';
  final addNewAddressUrl = '/diachikhachhang/ThemDiaChiKhachHang?khachHangId=';
  static final deleteAddressUrl = '/diachikhachhang/XoaDiaChiKhachHang?khachHangId=';
  final shippingfeeurl = '/services/shipment/fee';
  final getAddressByIdUrl = '/diachikhachhang/LayDiaChiKhachHang?khachHangId=';
  final setDefaultAddressUrl ='/diachikhachhang/SetDefaultDiaChiKhachHang?khachHangId=';
  final upadteAddressUrl ='/diachikhachhang/UpdateDiaChiKhachHang?khachHangId=';
  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');  // Trả về accessToken nếu có
  }
  // Hàm lưu id khách hàng vào SharedPreferences
  static Future<void> saveCustomerIdToPreferences(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('customerId', customerId);  // Lưu id khách hàng vào SharedPreferences
  }
  // Lấy danh sách địa chỉ khách hàng từ API
  Future<List<DiaChiKhachHang>> fetchDiaChiKhachHang() async {
    // Lấy token và customerId từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customerId');

    if (customerId == null) {
      throw Exception("Không tìm thấy Customer ID trong SharedPreferences.");
    }

    // Tạo URL đầy đủ
    final Uri url = Uri.parse('${APIConfig.baseURL}$addressUrl$customerId');

    // Gửi yêu cầu GET với header Authorization
    final response = await http.get(url);
    // Kiểm tra trạng thái phản hồi
    if (response.statusCode == 200) {
      // Parse JSON và chuyển đổi thành danh sách DiaChiKhachHang
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => DiaChiKhachHang.fromJson(item)).toList();
    } else {
      // Nếu có lỗi, ném Exception
      throw Exception('Không thể lấy danh sách địa chỉ: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
  // Hàm lấy địa chỉ mặc định
  Future<DiaChiKhachHang?> getDefaultAddress() async {
    try {
      // Lấy danh sách địa chỉ khách hàng
      List<DiaChiKhachHang> addresses = await fetchDiaChiKhachHang();

      // Kiểm tra nếu không có địa chỉ mặc định
      DiaChiKhachHang? defaultAddress;
      for (var address in addresses) {
        if (address.macDinh) {
          defaultAddress = address;
          break; // Dừng vòng lặp khi tìm thấy địa chỉ mặc định
        }
      }

      return defaultAddress; // Trả về địa chỉ mặc định nếu có, ngược lại trả về null
    } catch (e) {
      print("Lỗi khi lấy địa chỉ mặc định: $e");
      return null;  // Trả về null nếu có lỗi
    }
  }

  Future<ShippingResponse> calculateShippingFee(ShippingRequest request) async {
    final url = '${APIAddressConfig.giaohangTKURL}$shippingfeeurl';
    final token='${APIAddressConfig.token}';
    final source='${APIAddressConfig.source}';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Token': token,  // Token của bạn
          'X-Client-Source': source,  // X-Client-Source
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // Chuyển đổi dữ liệu trả về thành ShippingResponse và lấy fee
        return ShippingResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to calculate shipping fee');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<DiaChiKhachHang?> getAddressById(int? addressId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customerId');
    try {
      // Giả sử bạn gọi API lấy địa chỉ theo ID
      final response = await http.get(Uri.parse('${APIConfig.baseURL}$getAddressByIdUrl$customerId&diaChiKhachHangId=$addressId'));
      if (response.statusCode == 200) {
        return DiaChiKhachHang.fromJson(jsonDecode(response.body)); // Giả sử bạn đã có phương thức fromJson
      }
    } catch (e) {
      throw Exception('Failed to load address');
    }
  }
  // Hàm lấy danh sách tỉnh/thành phố
  Future<List<Province>> fetchProvinces() async {
    const String url = '${APIAddressConfig.addressURL}/province';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        // Parse danh sách tỉnh/thành phố
        return results.map((json) => Province.fromJson(json)).toList();
      } else {
        throw Exception(
            'Lỗi khi tải danh sách tỉnh/thành phố: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi gọi API: $e');
    }
  }
  // Hàm lấy danh sách quận/huyện từ API
  Future<List<District>> fetchDistrictsByProvinceId(String provinceId) async {
    final response = await http.get(
      Uri.parse('${APIAddressConfig.addressURL}/province/district/$provinceId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> results = data['results'];
      return results.map((district) => District.fromJson(district)).toList();
    } else {
      throw Exception('Không thể tải danh sách quận/huyện');
    }
  }
  Future<List<Ward>> fetchWardsByDistrictId(String districtId) async {
    // Gọi API để lấy danh sách phường/xã theo districtId
    final response = await http.get(Uri.parse('${APIAddressConfig.addressURL}/province/ward/$districtId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['results'];
      return jsonResponse.map((ward) => Ward.fromJson(ward)).toList();
    } else {
      throw Exception('Failed to load wards');
    }
  }
  Future<int?> addNewAddress(
      String tenNguoiNhan,
      String soDienThoaiNguoiNhan,
      String diaChiNguoiNhan,
      String xaPhuongNguoiNhan,
      String quanHuyenNguoiNhan,
      String tinhThanhNguoiNhan,
      bool macDinh,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customerId');

    final Map<String, dynamic> body = {
      "khachHangId": customerId,
      "tenNguoiNhan": tenNguoiNhan,
      "soDienThoaiNguoiNhan": soDienThoaiNguoiNhan,
      "diaChiNguoiNhan": diaChiNguoiNhan,
      "xaPhuongNguoiNhan": xaPhuongNguoiNhan,
      "quanHuyenNguoiNhan": quanHuyenNguoiNhan,
      "tinhThanhNguoiNhan": tinhThanhNguoiNhan,
      "macDinh": macDinh,
    };

    try {
      final response = await http.post(
        Uri.parse('${APIConfig.baseURL}$addNewAddressUrl$customerId'),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Phân tích phản hồi JSON
        final responseData = jsonDecode(response.body);
        int? addressId = responseData['id']; // Giả sử API trả về `id`
        print('Địa chỉ đã được thêm thành công với ID: $addressId');
        return addressId;
      } else {
        print('Lỗi khi thêm địa chỉ: ${response.statusCode}');
        print('Thông báo lỗi: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }
  Future<bool> setDefaultAddress(int diaChiKhachHangId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customerId');
    final url = '${APIConfig.baseURL}$setDefaultAddressUrl$customerId&diaChiKhachHangId=$diaChiKhachHangId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Địa chỉ mặc định đã được cập nhật thành công.');
        return true;
      } else {
        print('Lỗi khi cập nhật địa chỉ mặc định: ${response.statusCode}');
        print('Nội dung phản hồi: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi khi gửi yêu cầu PUT: $e');
      return false;
    }
  }
  Future<void> updateAddress({
    required int diaChiKhachHangId,
    required String tenNguoiNhan,
    required String soDienThoaiNguoiNhan,
    required String diaChiNguoiNhan,
    required String xaPhuongNguoiNhan,
    required String quanHuyenNguoiNhan,
    required String tinhThanhNguoiNhan,
    required bool macDinh,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customerId');
    final url = '${APIConfig.baseURL}$upadteAddressUrl$customerId&diaChiKhachHangId=$diaChiKhachHangId';

    final Map<String, dynamic> body = {
      "id": diaChiKhachHangId,
      "khachHangId": customerId,
      "tenNguoiNhan": tenNguoiNhan,
      "soDienThoaiNguoiNhan": soDienThoaiNguoiNhan,
      "diaChiNguoiNhan": diaChiNguoiNhan,
      "xaPhuongNguoiNhan": xaPhuongNguoiNhan,
      "quanHuyenNguoiNhan": quanHuyenNguoiNhan,
      "tinhThanhNguoiNhan": tinhThanhNguoiNhan,
      "macDinh": macDinh
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Cập nhật địa chỉ thành công');
      } else {
        print('Lỗi khi cập nhật địa chỉ: ${response.statusCode}');
        print('Phản hồi từ server: ${response.body}');
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
    }
  }
  // Phương thức xóa địa chỉ
  static Future<void> deleteAddress(int diaChiKhachHangId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? customerId = prefs.getString('customerId');

      final url = Uri.parse('${APIConfig.baseURL}$deleteAddressUrl$customerId&diaChiKhachHangId=$diaChiKhachHangId');

      final response = await http.delete(url, headers: {'accept': '*/*'});

      if (response.statusCode == 200) {
        print('Địa chỉ đã được xóa');
      } else {
        throw Exception('Không thể xóa địa chỉ: ${response.body}');
      }
    } catch (e) {
      print('Lỗi khi xóa địa chỉ: $e');
      rethrow;
    }
  }
}


