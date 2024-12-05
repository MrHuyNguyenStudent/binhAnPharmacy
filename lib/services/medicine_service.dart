import 'dart:convert';
import 'package:binh_an_pharmacy/api/url_api.dart';
import 'package:binh_an_pharmacy/models/medicine_model.dart';
import 'package:http/http.dart' as http;

class ApiMedicineServices {
  final String productUrl = '/sanpham/GetSanPhams';
  final String getProductUrl='/sanpham/GetSanPham/';
  final String phienbanproductUrl = '/phienbansanpham/GetPhienBanSanPhamByPhienBanId/';
  Future<List<Medicine>> fetchMedicinesByCategory(String categoryId) async {
    try {
      final response = await http.get(Uri.parse('${APIConfig.baseURL}$productUrl'));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);

        // Chuyển đổi JSON thành danh sách các đối tượng Medicine
        List<Medicine> allMedicines = jsonList.map((json) => Medicine.fromJson(json)).toList();
        // Lọc danh sách thuốc theo danh mục ID
        return allMedicines.where((medicine) => medicine.danhMucId == categoryId).toList();
      } else {
        throw Exception('Failed to load medicines');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  // Fetch all medicines
  Future<List<Medicine>> fetchAllMedicines() async {
    try {
      final response = await http.get(Uri.parse('${APIConfig.baseURL}$productUrl'));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<Medicine> allMedicines = jsonList.map((json) => Medicine.fromJson(json)).toList();
        return allMedicines;
      } else {
        throw Exception('Failed to load medicines');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  // Fetch all medicines
  Future<Medicine> getMedicines(String id) async {
      final url = Uri.parse('${APIConfig.baseURL}$getProductUrl$id');

      try {
        final response = await http.get(
          url,
          headers: {
            'accept': '*/*',
          },
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          return Medicine.fromJson(json);
        } else {
          throw Exception(
              'Failed to load medicine. Status code: ${response.statusCode}');
        }
      } catch (error) {
        throw Exception('Error fetching medicine: $error');
      }
    }
  Future<List<Medicine>> getMedicinesByName(String name) async {
    final String byNameUrl = '/sanpham/GetSanPhamByName?name=${Uri.encodeComponent(name)}';
    try {
      final response = await http.get(Uri.parse('${APIConfig.baseURL}$byNameUrl'));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<Medicine> allMedicines = jsonList.map((json) => Medicine.fromJson(json)).toList();
        return allMedicines;
      } else {
        throw Exception('Failed to load medicines');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<PhienBan> getProductVersion(String id) async {
    final response = await http.get(Uri.parse('${APIConfig.baseURL}$phienbanproductUrl$id'));

    if (response.statusCode == 200) {
      return PhienBan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể lấy thông tin phiên bản sản phẩm');
    }
  }
  Future<Medicine> getFullMedicineInfo(String phienBanId) async {
    try {
      // Bước 1: Lấy thông tin phiên bản sản phẩm
      PhienBan phienBan = await getProductVersion(phienBanId);

      // Bước 2: Sử dụng maSanPham để lấy thông tin chi tiết sản phẩm
      Medicine medicine = await getMedicines(phienBan.maSanPham);

      return medicine;
    } catch (error) {
      throw Exception('Không thể lấy thông tin sản phẩm đầy đủ: $error');
    }
  }

}
