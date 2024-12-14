import 'package:binh_an_pharmacy/providers/cart_provider.dart';
import 'package:binh_an_pharmacy/screens/checkout_now_screen.dart';
import 'package:binh_an_pharmacy/screens/checkout_screen.dart';
import 'package:binh_an_pharmacy/screens/welcome_screen.dart';
import 'package:binh_an_pharmacy/services/cart_item_services.dart';
import 'package:binh_an_pharmacy/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:binh_an_pharmacy/models/medicine_model.dart';
import 'package:provider/provider.dart';

class ProductSelectionBottomSheet extends StatelessWidget {
  final Medicine product;

  ProductSelectionBottomSheet({required this.product});

  @override
  Widget build(BuildContext context) {
    String? selectedOption = product.danhSachPhienBan.isNotEmpty
        ? product.danhSachPhienBan[0].donViQuyDoi
        : null; // Đơn vị quy đổi mặc định
    double selectedPrice = product.danhSachPhienBan.isNotEmpty
        ? product.danhSachPhienBan[0].giaBanQuyDoi
        : 0.0; // Giá mặc định
    int quantity = 1;
    double totalPrice = selectedPrice * quantity; // Tổng tiền ban đầu

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chọn sản phẩm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Image.network(
                    product.anhSanPham,
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.tenSanPham,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${totalPrice.toStringAsFixed(0)} đ', // Hiển thị tổng tiền
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Phân loại sản phẩm'),
              Wrap(
                spacing: 8,
                children: product.danhSachPhienBan.map((phienBan) {
                  return ChoiceChip(
                    label: Text(phienBan.donViQuyDoi),
                    selected: selectedOption == phienBan.donViQuyDoi,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedOption = phienBan.donViQuyDoi;
                          selectedPrice = phienBan.giaBanQuyDoi;
                          totalPrice = selectedPrice * quantity; // Cập nhật tổng tiền
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Text('Số lượng'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) quantity--;
                        totalPrice = selectedPrice * quantity; // Cập nhật tổng tiền khi giảm số lượng
                      });
                    },
                  ),
                  Text('$quantity', style: TextStyle(fontSize: 16)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                        totalPrice = selectedPrice * quantity; // Cập nhật tổng tiền khi tăng số lượng
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          String? khachHangId = await UserService.getAccessToken();
                          print("id ${khachHangId}");
                          if (khachHangId == null) {
                            // Hiển thị thông báo
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Bạn cần đăng nhập để tiếp tục'),
                                backgroundColor: Colors.teal,
                              ),
                            );
                            // Điều hướng về màn hình đăng nhập
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => WelcomeScreen()),
                            );
                            return; // Dừng việc thực hiện tiếp
                          }
                          // Lấy ID phiên bản sản phẩm
                          final selectedPhienBan = product.danhSachPhienBan.firstWhere(
                                (phienBan) => phienBan.donViQuyDoi == selectedOption,
                          );
                          // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
                          final cartService = CartItemServices();
                            bool success = await cartService.updateProductQuantity(
                              khachHangId: khachHangId,
                              phienBanSanPhamId: selectedPhienBan.id,
                              newQuantity: quantity,
                            );
                          if (success) {
                            Provider.of<CartProvider>(context, listen: false).loadCartItems();
                            // Sử dụng BuildContext của ProductSelectionBottomSheet
                            setState(() {
                              showPaseMessage(context, 'Thêm vào giỏ hàng thành công!');
                            });
                          }
                        } catch (e) {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Thêm vào giỏ hàng thất bại: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 12), // Padding cho nút
                      ),
                      child: Text('Thêm vào giỏ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          String? khachHangId = await UserService.getAccessToken();
                          print("id ${khachHangId}");
                          if (khachHangId == null) {
                            // Hiển thị thông báo
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Bạn cần đăng nhập để tiếp tục'),
                                backgroundColor: Colors.teal,
                              ),
                            );
                            // Điều hướng về màn hình đăng nhập
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => WelcomeScreen()),
                            );
                            return; // Dừng việc thực hiện tiếp
                          }
                          // Kiểm tra nếu tổng giá trị đơn hàng nhỏ hơn 10,000
                          if (totalPrice < 10000) {
                            // Hiển thị thông báo lên trên màn hình bằng Overlay
                            showOverlayMessage(context, 'Hệ thống chỉ nhận đơn hàng lớn hơn 10,000 đ');
                            return; // Dừng lại, không tiếp tục với bước thanh toán
                          }
                          // Lấy thông tin phiên bản sản phẩm được chọn
                          final selectedPhienBan = product.danhSachPhienBan.firstWhere(
                                (phienBan) => phienBan.donViQuyDoi == selectedOption,
                          );

                          // Chuyển đến màn hình CheckoutNowScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutNowScreen(
                                phienBanSanPhamId: selectedPhienBan.id,
                                quantity: quantity,
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Không thể chuyển đến màn hình thanh toán: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Mua ngay',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

void showOverlayMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 10,  // Vị trí thông báo ở dưới cùng
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );

  // Thêm overlay vào màn hình
  overlay.insert(overlayEntry);

  // Xóa overlay sau 3 giây
  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
void showPaseMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 10,  // Vị trí thông báo ở dưới cùng
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );

  // Thêm overlay vào màn hình
  overlay.insert(overlayEntry);

  // Xóa overlay sau 3 giây
  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}