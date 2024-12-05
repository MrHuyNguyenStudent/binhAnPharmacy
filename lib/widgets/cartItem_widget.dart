import 'package:binh_an_pharmacy/providers/cart_provider.dart';
import 'package:binh_an_pharmacy/services/cart_item_services.dart';
import 'package:flutter/material.dart';
import 'package:binh_an_pharmacy/models/cart_item_model.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<bool> onSelected;

  CartItemWidget({
    required this.item,
    required this.onQuantityChanged,
    required this.onSelected,
  });
  final CartItemServices cartItemServices = CartItemServices();
  void _decreaseQuantity(BuildContext context) async {
    if (item.soLuong == 1) {
      await cartItemServices.removeProductFromCart(item.phienBanSanPhamId);
      Provider.of<CartProvider>(context, listen: false).removeFromCart(item.phienBanSanPhamId);
    }else{
      final decrease = await cartItemServices.decreaseProductQuantity(item.phienBanSanPhamId);
      if (decrease==true) {
        onQuantityChanged(item.soLuong-1);
      }
    }
  }
  void _increaseQuantity(BuildContext context) async {
    final increase = await cartItemServices.increaseProductQuantity(item.phienBanSanPhamId);
    if (increase==true) {
      onQuantityChanged(item.soLuong+1);
    }
  }
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
    return ListTile(
      leading: Checkbox(
        value: item.selected,
        onChanged: (selected) {
          onSelected(selected ?? false);
        },
      ),
      title: Text(
        item.tenSanPham,
        overflow: TextOverflow.ellipsis,
        maxLines: 1, // Giới hạn tối đa 1 dòng
      ),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Giá: ${formatCurrency(item.gia)} đ'),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  _decreaseQuantity(context);
                },
              ),
              Text('${item.soLuong}'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _increaseQuantity(context);
                },
              ),
            ],
          ),
        ],
      ),
      trailing: Image.network(
        item.hinhAnh,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }
}
