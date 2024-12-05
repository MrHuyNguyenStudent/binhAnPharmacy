import 'package:binh_an_pharmacy/models/category_description_model.dart';
import 'package:binh_an_pharmacy/models/category_model.dart';
import 'package:binh_an_pharmacy/screens/medicine_list_screen.dart';
import 'package:binh_an_pharmacy/services/category_service.dart';
import 'package:binh_an_pharmacy/widgets/bottom_nav_bar_widget.dart';
import 'package:flutter/material.dart';


class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> uniqueCategoryNames = [];
  List<CategoryDescription> categoryDescriptions = [];
  bool isLoading = false;
  String selectedCategoryName = "";
  int _selectedCategoryIndex = -1;
  int _selectedIndex = 1;

  final List<Map<String, String>> categoryNames = [
    {"name": "Thuốc", "image": "lib/assets/category/thuoc.png"},
    {"name": "Thực phẩm chức năng", "image": "lib/assets/category/thucphamchucnang.png"},
    {"name": "Chăm sóc cá nhân", "image": "lib/assets/category/chamsoccanhan.png"},
    {"name": "Mẹ và Bé", "image": "lib/assets/category/mebe.png"},
    {"name": "Chăm sóc sắc đẹp", "image": "lib/assets/category/chamsocsacdep.png"},
    {"name": "Thiết bị y tế", "image": "lib/assets/category/thietbiyte.png"},
    {"name": "Sản phẩm tiện lợi", "image": "lib/assets/category/sanphamtienloi.png"},
    {"name": "Chăm sóc sức khỏe", "image": "lib/assets/category/chamsocsuckhoe.png"},
  ];
  // Hàm gọi API để lấy danh sách tên danh mục
  void fetchUniqueCategories() async {
    setState(() {
      isLoading = true;
    });

    try {
      CategoryService categoryService = CategoryService();
      List<String> categoryNames = await categoryService.fetchUniqueCategoryNames();

      setState(() {
        uniqueCategoryNames = categoryNames;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching category names: $e");
    }
  }

  // Hàm gọi API để lấy mô tả của danh mục đã chọn
  void fetchCategoryDescriptions(String categoryName) async {
    setState(() {
      isLoading = true;
    });

    try {
      CategoryService categoryService = CategoryService();
      List<CategoryDescription> descriptions = await categoryService.fetchCategoryDescriptions(categoryName);
      print('Descriptions for $categoryName: $descriptions');
      setState(() {
        categoryDescriptions = descriptions;
        isLoading = false;
        selectedCategoryName = categoryName;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching category descriptions: $e");
    }
  }
  @override
  void initState() {
    super.initState();
    // Lấy danh sách tên danh mục khi màn hình được khởi tạo
    fetchUniqueCategories();
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  // // Navigate to MedicineListScreen with the selected category ID
  // void _navigateToMedicineListScreen(String categoryId) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MedicineListScreen(categoryId: categoryId),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh mục sản phẩm'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị loading nếu dữ liệu đang được tải
          : Row(
        children: [
          // Sidebar hiển thị danh mục chính
          Container(
            width: 130,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: categoryNames.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index; // Cập nhật chỉ số danh mục được chọn
                    });
                    // Khi người dùng chọn danh mục
                    fetchCategoryDescriptions(categoryNames[index]["name"]!);
                  },
                  child: Container(
                    color: _selectedCategoryIndex  == index
                        ? Colors.white
                        : Colors.grey[200],
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 40, // Điều chỉnh kích thước hình ảnh
                          height: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(categoryNames[index]["image"]!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            categoryNames[index]["name"]!,
                            style: TextStyle(
                              color: _selectedCategoryIndex == index
                                  ? Colors.teal
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Phần hiển thị mô tả của danh mục đã chọn
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: categoryDescriptions.isEmpty
                  ? Center(child: Text('Chọn danh mục để xem mô tả'))
                  : ListView.builder(
                itemCount: categoryDescriptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicineListScreen(
                            categoryId: categoryDescriptions[index].id,categoryName:categoryDescriptions[index].moTa// Truyền id danh mục
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryDescriptions[index].moTa,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
