import 'dart:convert';
import 'package:binh_an_pharmacy/api/url_api.dart';
import 'package:binh_an_pharmacy/models/medicine_model.dart';
import 'package:http/http.dart' as http;

class ApiProductVersionService {
  final String phienbanproductUrl = '/phienbansanpham/GetPhienBanSanPhamByPhienBanId/';
  Future<PhienBan> getProductVersion(String id) async {
    final response = await http.get(Uri.parse('${APIConfig.baseURL}$phienbanproductUrl$id'));

    if (response.statusCode == 200) {
      return PhienBan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể lấy thông tin phiên bản sản phẩm');
    }
  }
}
