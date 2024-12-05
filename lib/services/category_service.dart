import 'dart:convert';
import 'package:binh_an_pharmacy/api/url_api.dart';
import 'package:binh_an_pharmacy/models/category_description_model.dart';
import 'package:binh_an_pharmacy/models/category_model.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String getcategoriesUrl = '/category/GetCategories';
  final String getcategoryDescriptionsUrl = "/category/GetCategoriesByName";
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('${APIConfig.baseURL}$getcategoriesUrl'));

      if (response.statusCode == 200) {
        // Giải mã JSON và chuyển thành danh sách các đối tượng Category
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<List<String>> fetchUniqueCategoryNames() async {
    final response = await http.get(Uri.parse('${APIConfig.baseURL}$getcategoriesUrl'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Lấy tất cả các tên danh mục (tenDanhMuc) và loại bỏ trùng lặp
      Set<String> uniqueCategoryNames = Set();
      for (var item in data) {
        uniqueCategoryNames.add(item['tenDanhMuc']);
      }

      return uniqueCategoryNames.toList();
    } else {
      throw Exception('Failed to load category names');
    }
  }

  // Hàm lấy mô tả theo tên danh mục
  Future<List<CategoryDescription>> fetchCategoryDescriptions(String categoryName) async {
    final response = await http.get(Uri.parse('${APIConfig.baseURL}$getcategoryDescriptionsUrl/$categoryName'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CategoryDescription.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load category descriptions');
    }
  }
}
