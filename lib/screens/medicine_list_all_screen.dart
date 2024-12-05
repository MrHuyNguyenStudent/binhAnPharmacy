import 'package:binh_an_pharmacy/models/medicine_model.dart';
import 'package:binh_an_pharmacy/providers/cart_provider.dart';
import 'package:binh_an_pharmacy/screens/cart_screen.dart';
import 'package:binh_an_pharmacy/screens/medicine_detail_screen.dart';
import 'package:binh_an_pharmacy/services/medicine_service.dart';
import 'package:binh_an_pharmacy/widgets/filter_button_widget.dart';
import 'package:binh_an_pharmacy/widgets/medicines_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineListAllScreen extends StatefulWidget {
  @override
  _MedicineListAllScreenState createState() => _MedicineListAllScreenState();
}

class _MedicineListAllScreenState extends State<MedicineListAllScreen> {
  bool isLoading = true;
  List<Medicine> medicines = [];
  final ApiMedicineServices apiMedicineServices=ApiMedicineServices();

  // Hàm gọi API để lấy danh sách sản phẩm theo categoryId
  void fetchMedicines() async {
    setState(() {
      isLoading = true; // Đặt isLoading là true khi bắt đầu lấy dữ liệu
    });

    try {
      // Gọi API để lấy danh sách sản phẩm theo categoryId
      List<Medicine> medicineList = await apiMedicineServices.fetchAllMedicines();

      setState(() {
        medicines = medicineList; // Cập nhật danh sách sản phẩm
        isLoading = false; // Đặt isLoading là false khi lấy dữ liệu xong
      });
      print("Medicines fetched: $medicines");
    } catch (e) {
      setState(() {
        isLoading = false; // Đặt isLoading là false nếu có lỗi
      });
      print("Error fetching medicines: $e");
    }
  }
// Hàm để sắp xếp sản phẩm theo giá tăng dần
  void sortByPriceAscending() {
    setState(() {
      medicines.sort((a, b) => a.danhSachPhienBan.isNotEmpty && b.danhSachPhienBan.isNotEmpty
          ? a.danhSachPhienBan[0].giaBanQuyDoi.compareTo(b.danhSachPhienBan[0].giaBanQuyDoi)
          : 0);
    });
  }

  // Hàm để sắp xếp sản phẩm theo giá giảm dần
  void sortByPriceDescending() {
    setState(() {
      medicines.sort((a, b) => a.danhSachPhienBan.isNotEmpty && b.danhSachPhienBan.isNotEmpty
          ? b.danhSachPhienBan[0].giaBanQuyDoi.compareTo(a.danhSachPhienBan[0].giaBanQuyDoi)
          : 0);
    });
  }
  @override
  void initState() {
    super.initState();
    fetchMedicines(); // Gọi hàm fetchMedicines khi màn hình được khởi tạo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading
            ? Text('Đang tải...') // Nếu đang tải dữ liệu, hiển thị "Đang tải..."
            : Text('Danh sách thuốc'), // Hiển thị tên hoặc mô tả của danh mục
        backgroundColor: Colors.teal,
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //Bộ lọc sản phẩm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterButton(
                  label: 'Bộ lọc',
                  onPressed: () {}, // Xử lý bộ lọc tùy chỉnh nếu cần
                ),
                FilterButton(
                  label: 'Giá giảm dần',
                  onPressed: sortByPriceDescending, // Gọi hàm sắp xếp giảm dần
                ),
                FilterButton(
                  label: 'Giá tăng dần',
                  onPressed: sortByPriceAscending, // Gọi hàm sắp xếp tăng dần
                ),
              ],
            ),
            //Hiển thị sản phẩm
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator()) // Hiển thị loading nếu đang tải dữ liệu
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Chia grid thành 2 cột
                  childAspectRatio: 0.7, // Tỷ lệ chiều rộng/chiều cao của mỗi item
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: medicines.length, // Số lượng sản phẩm trong danh sách
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Khi nhấn vào thuốc, chuyển đến màn hình chi tiết thuốc
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicineDetailScreen(
                            medicine: medicines[index], // Truyền thông tin thuốc sang màn hình chi tiết
                          ),
                        ),
                      );
                    },
                    child: MedicinesCardWidget(product: medicines[index]), // Hiển thị sản phẩm trong thẻ
                  ); // Hiển thị sản phẩm trong thẻ
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}