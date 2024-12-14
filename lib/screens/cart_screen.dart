import 'package:binh_an_pharmacy/providers/cart_provider.dart';
import 'package:binh_an_pharmacy/screens/checkout_screen.dart';
import 'package:binh_an_pharmacy/screens/home_screen.dart';
import 'package:binh_an_pharmacy/screens/welcome_screen.dart';
import 'package:binh_an_pharmacy/services/cart_item_services.dart';
import 'package:binh_an_pharmacy/services/user_service.dart';
import 'package:binh_an_pharmacy/widgets/cartItem_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartItemServices cartItemServices=CartItemServices();
  @override
  void initState() {
    super.initState();
    // Load giỏ hàng từ CartProvider khi màn hình được khởi tạo
    Provider.of<CartProvider>(context, listen: false).loadCartItems();
  }

  //format
  String formatCurrency(double value) {
    // Chuyển giá trị thành chuỗi
    String valueStr = value.toStringAsFixed(2);

    // Tách phần nguyên và phần thập phân
    List<String> parts = valueStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    // Thêm dấu phẩy vào phần nguyên
    String formattedInteger = '';
    int count = 0;

    // Duyệt qua phần nguyên từ phải qua trái và thêm dấu phẩy mỗi ba chữ số
    for (int i = integerPart.length - 1; i >= 0; i--) {
      count++;
      formattedInteger = integerPart[i] + formattedInteger;
      if (count % 3 == 0 && i != 0) {
        formattedInteger = ',' + formattedInteger;
      }
    }

    // Nối phần nguyên và phần thập phân
    return formattedInteger + '.' + decimalPart;
  }
  @override
  Widget build(BuildContext context) {
    // Sử dụng CartProvider để lấy danh sách các sản phẩm trong giỏ hàng
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () async {
              // Xóa các sản phẩm đã chọn
              await cartProvider.removeSelectedItems();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (context, index) {
          final item = cartProvider.cartItems[index];
          return CartItemWidget(
            item: item,
            onQuantityChanged: (newQuantity) {
              cartProvider.updateItemQuantity(item, newQuantity.toInt());
            },
            onSelected: (selected) {
              cartProvider.toggleItemSelection(item, selected);
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: cartProvider.cartItems.every((item) => item.selected),
                    onChanged: (selected) {
                      setState(() {
                        for (var item in cartProvider.cartItems) {
                          item.selected = selected!;
                        }
                      });
                    },
                  ),
                  Text('Tất cả'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tổng tiền:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${formatCurrency(cartProvider.calculateTotalPrice())} đ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (cartProvider.calculateTotalPrice() == 0) {
                    // Hiển thị thông báo nếu tổng giá trị giỏ hàng < 0
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Chọn vào sản phẩm bạn muốn thanh toán!'),
                      backgroundColor: Colors.teal, // Màu sắc thông báo
                    ));
                  } else if (cartProvider.calculateTotalPrice() < 10000 && cartProvider.calculateTotalPrice() > 0) {
                    // Hiển thị thông báo nếu tổng giá trị giỏ hàng nhỏ hơn 10.000
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Hệ thống chỉ chấp nhận đơn hàng lớn hơn 10.000 đ'),
                      backgroundColor: Colors.teal, // Màu sắc thông báo
                    ));
                  } else if (cartProvider.calculateTotalPrice() > 0) {
                    // Nếu tổng giá trị giỏ hàng hợp lệ, chuyển đến màn hình thanh toán
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(cartItems: cartProvider.cartItems),
                      ),
                    );
                  }
                },
                child: Text('Mua hàng (${cartProvider.selectedItemsCount()})'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white,),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
