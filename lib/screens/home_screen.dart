import 'package:binh_an_pharmacy/models/medicine_model.dart';
import 'package:binh_an_pharmacy/providers/cart_provider.dart';
import 'package:binh_an_pharmacy/screens/cart_screen.dart';
import 'package:binh_an_pharmacy/screens/medicine_detail_screen.dart';
import 'package:binh_an_pharmacy/screens/medicine_list_all_screen.dart';
import 'package:binh_an_pharmacy/screens/welcome_screen.dart';
import 'package:binh_an_pharmacy/services/medicine_service.dart';
import 'package:binh_an_pharmacy/widgets/bottom_nav_bar_widget.dart';
import 'package:binh_an_pharmacy/widgets/medicines_card_widget.dart';
import 'package:binh_an_pharmacy/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<Medicine>> _medicines;
  TextEditingController _searchController = TextEditingController(); // Controller cho ô tìm kiếm
  @override
  void initState() {
    super.initState();
    _medicines = ApiMedicineServices().fetchAllMedicines();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).loadCartItems();
    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
// Hàm xử lý tìm kiếm
  void _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _medicines = ApiMedicineServices().fetchAllMedicines();  // Khi không có từ khóa tìm kiếm, hiển thị tất cả sản phẩm
      });
    } else {
      try {
        // Tìm kiếm sản phẩm theo tên
        List<Medicine> medicines = await ApiMedicineServices().getMedicinesByName(query);
        setState(() {
          _medicines = Future.value(medicines);  // Cập nhật danh sách thuốc
        });
      } catch (e) {
        // Hiển thị thông báo lỗi nếu có
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi khi tìm kiếm: $e")),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.person, color: Colors.teal),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
            ),
          ],
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  ),
                  if (cartProvider.cartItems.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cartProvider.cartItems.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],

      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchWidget(
              controller: _searchController,
              onSearch: _onSearch,
            ),
            SizedBox(height: screenHeight * 0.01),

            // Order Medicine Banner
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Khuyến mãi lớn",
                        style: TextStyle(fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text("Hàng triệu đơn giảm giá."),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        "Giảm đến 60% ",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                        child: Text("Mua ngay"),
                      ),
                    ],
                  ),
                  Spacer(),
                  Image.asset(
                    "lib/assets/logo1.png",
                    // Thay URL hình ảnh của người giao hàng ở đây
                    width: screenWidth * 0.2,
                    height: screenWidth * 0.2,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildCategoryItem(
                    Icons.phone_callback_outlined, "Liên hệ dược sỹ",
                    screenWidth),
                buildCategoryItem(Icons.discount, "Mã giảm riêng", screenWidth),
                buildCategoryItem(
                    Icons.heart_broken, "Kiểm tra sức khỏe", screenWidth),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            // Recommended Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sản phẩm bán chạy",
                  style: TextStyle(fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicineListAllScreen()),
                    );
                  },
                  child: Text("Xem tất cả"),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: FutureBuilder<List<Medicine>>(
                future: _medicines,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // Show loading indicator while fetching
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}')); // Show error message if any
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có sản phẩm thuốc')); // Show message if no medicines are found
                  } else {
                    List<Medicine> medicines = snapshot.data!;

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Chia grid thành 2 cột
                        childAspectRatio: 0.7, // Tỷ lệ chiều rộng/chiều cao của mỗi item
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: medicines.length,
                      itemBuilder: (context, index) {
                        Medicine medicine = medicines[index];
                        return GestureDetector(
                          onTap: () {
                            // Khi nhấn vào thuốc, chuyển đến màn hình chi tiết thuốc
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineDetailScreen(
                                  medicine: medicine, // Truyền thông tin thuốc sang màn hình chi tiết
                                ),
                              ),
                            );
                          },
                          child: MedicinesCardWidget(product: medicine), // Hiển thị sản phẩm trong thẻ
                        );
                      },
                    );
                  }
                },

              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        // isLoggedIn: isLoggedIn,
      ),
    );
  }

  Widget buildCategoryItem(IconData icon, String label, double screenWidth) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.teal, size: screenWidth * 0.08),
        ),
        SizedBox(height: screenWidth * 0.02),
        Text(label, style: TextStyle(fontSize: screenWidth * 0.035)),
      ],
    );
  }
}