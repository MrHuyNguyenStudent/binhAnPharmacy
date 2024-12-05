import 'dart:convert';
import 'package:binh_an_pharmacy/api/url_api.dart';
import 'package:binh_an_pharmacy/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiOrdersService {
  final String orderonlineUrl = '/hoadonbanhang/AddHoaDonBanHangOnline?token=';
  final String getorderUrl = '/khachhang/GetHoaDonKhacHangByID?id=';
  final String getOrderDelivereUrl = '/hoadonbanhang/GetHoaDonBanHangOnlineDaGiao';
  final String getAllUrl='/hoadonbanhang/GetHoaDonBanHangOnlineByTokenKhachHang?token=';
  final String getHoaDonDetailUrl ='/hoadonbanhang/GetHoaDonBanHangOnlineByID?hoaDonId=';
  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');  // Trả về accessToken nếu có
  }
  // Hàm lưu id khách hàng vào SharedPreferences
  static Future<void> saveCustomerIdToPreferences(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('customerId', customerId);  // Lưu id khách hàng vào SharedPreferences
  }
  Future<void> addOrderOnline(String tenNguoiNhan,String soDienThoaiNguoiNhan,String diaChiNguoiNhan, String xaPhuongNguoiNhan, String quanHuyenNguoiNhan, String tinhThanhNguoiNhan, String payment, String note, String code, List<OrderItem> orderItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? customerId = prefs.getString('customerId');
    final url = Uri.parse('${APIConfig.baseURL}$orderonlineUrl$token&TenNguoiNhan=$tenNguoiNhan&SoDienThoaiNguoiNhan=$soDienThoaiNguoiNhan&DiaChiNguoiNhan=$diaChiNguoiNhan&XaPhuongNguoiNhan=$xaPhuongNguoiNhan&QuanHuyenNguoiNhan=$quanHuyenNguoiNhan&TinhThanhNguoiNhan=$tinhThanhNguoiNhan');

    // Tạo danh sách chi tiết hóa đơn từ danh sách OrderItem
    List<Map<String, dynamic>> chiTietHoaDonBanHangs = orderItems.map((item) => item.toJson()).toList();

    final body = json.encode({
      "khachHangId": customerId,
      "nhanVienId": "string",
      "khuyenMaiId": code,
      "hinhThucMuaHang": "string",
      "hinhThucThanhToan": payment,
      "trangThaiDonHang": "string",
      "trangThaiThanhToan": "string",
      "tongTien": 0,
      "thue": 0,
      "thanhTien": 0,
      "loaiHoaDon": "string",
      "phiVanChuyen": 0,
      "dungTichDiem": true,
      "soDiemTichLuyDung": 0,
      "ghiChu": note,
      "chiTietHoaDonBanHangs": orderItems.map((item) => {
        "id":item.id,
        "hoaDonId": item.hoaDonId,
        "phienBanSanPhamId": item.phienBanSanPhamId,
        "soLuong": item.soLuong,
        "gia": item.gia,
      }).toList(),
      "giaoHangId": "string",
      "giaoHang": {
        "id": "string",
        "maDonRutGon": "string",
        "tenNguoiGui": "string",
        "soDienThoaiNguoiGui": "string",
        "diaChiNguoiGui": "string",
        "quanHuyenNguoiGui": "string",
        "tinhThanhNguoiGui": "string",
        "tenNguoiNhan": "string",
        "soDienThoaiNguoiNhan": "string",
        "diaChiNguoiNhan": "string",
        "xaPhuongNguoiNhan": "string",
        "quanHuyenNguoiNhan": "string",
        "tinhThanhNguoiNhan": "string",
        "trackingNumber": 0,
        "thoiGianLayHangDuKien": "string",
        "thoiGianGiaoHangDuKien": "string"
      },
      "timeline": [
        {
          "id": 0,
          "hoaDonBanHangId": "string",
          "status": "string",
          "thoiGian": "2024-12-03T15:47:27.216Z",
          "ghiChu": "string"
        }
      ]
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        print('Order placed successfully: ${response.body}');
        // Có thể API trả về thông tin chi tiết về lỗi
      }if (response.statusCode == 400) {
        print('Error response: ${response.body}');
      } else {
        print('Failed to place order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> addOrderNow(String tenNguoiNhan,String soDienThoaiNguoiNhan,String diaChiNguoiNhan, String xaPhuongNguoiNhan, String quanHuyenNguoiNhan, String tinhThanhNguoiNhan, String payment, String note, String code, String phienBanSanPhamId, int soLuong) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? customerId = prefs.getString('customerId');
    final url = Uri.parse('${APIConfig.baseURL}$orderonlineUrl$token&TenNguoiNhan=$tenNguoiNhan&SoDienThoaiNguoiNhan=$soDienThoaiNguoiNhan&DiaChiNguoiNhan=$diaChiNguoiNhan&XaPhuongNguoiNhan=$xaPhuongNguoiNhan&QuanHuyenNguoiNhan=$quanHuyenNguoiNhan&TinhThanhNguoiNhan=$tinhThanhNguoiNhan');

    final body = json.encode({
      "id": "string",
      "khachHangId": customerId,
      "nhanVienId": "string",
      "khuyenMaiId": code,
      "hinhThucMuaHang": "string",
      "hinhThucThanhToan": payment,
      "trangThaiDonHang": "string",
      "trangThaiThanhToan": "string",
      "tongTien": 0,
      "thue": 0,
      "thanhTien": 0,
      "loaiHoaDon": "string",
      "phiVanChuyen": 0,
      "dungTichDiem": true,
      "soDiemTichLuyDung": 0,
      "ghiChu": note,
      "chiTietHoaDonBanHangs": [
        {
          "id": "string",
          "hoaDonId": "string",
          "phienBanSanPhamId": phienBanSanPhamId,
          "soLuong": soLuong,
          "gia": 0
        }
      ],
      "giaoHang": {
        "id": "string",
        "maDonRutGon": "string",
        "tenNguoiGui": "string",
        "soDienThoaiNguoiGui": "string",
        "diaChiNguoiGui": "string",
        "quanHuyenNguoiGui": "string",
        "tinhThanhNguoiGui": "string",
        "tenNguoiNhan": "string",
        "soDienThoaiNguoiNhan": "string",
        "diaChiNguoiNhan": "string",
        "xaPhuongNguoiNhan": "string",
        "quanHuyenNguoiNhan": "string",
        "tinhThanhNguoiNhan": "string",
        "trackingNumber": 0,
        "thoiGianLayHangDuKien": "string",
        "thoiGianGiaoHangDuKien": "string"
      },
      "timeline": [
        {
          "id": 0,
          "hoaDonBanHangId": "string",
          "status": "string",
          "thoiGian": "2024-12-03T15:47:27.216Z",
          "ghiChu": "string"
        }
      ]
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        print('Order placed successfully: ${response.body}');
        // Có thể API trả về thông tin chi tiết về lỗi
      }if (response.statusCode == 400) {
        print('Error response: ${response.body}');
      } else {
        print('Failed to place order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

// Hàm lấy chi tiết hóa đơn theo hoaDonId
  Future<Map<String, dynamic>> fetchHoaDonDetail(String hoaDonId) async {
    // URL API để lấy chi tiết hóa đơn theo ID
    final url = Uri.parse('${APIConfig.baseURL}$getHoaDonDetailUrl$hoaDonId');

    try {
      final response = await http.get(url, headers: {'accept': '*/*'});

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Không thể lấy chi tiết hóa đơn');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<HoaDon>> getAllHoaDon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final String url = '${APIConfig.baseURL}$getAllUrl$token';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'accept': '*/*'},
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<HoaDon> hoaDons = HoaDon.fromJsonList(jsonList);
        List<dynamic> data = json.decode(response.body);
        print("Error fetching HoaDon: $data");
        // Chuyển đổi danh sách JSON thành danh sách đối tượng HoaDon
        return data.map((json) => HoaDon.fromJson(json)).toList();
      } else {
        print("Failed to load HoaDon: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching HoaDon: $e");
      return [];
    }
  }

}
