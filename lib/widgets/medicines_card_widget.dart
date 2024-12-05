import 'package:binh_an_pharmacy/models/medicine_model.dart';
import 'package:binh_an_pharmacy/widgets/product_selectionbottom_sheet.dart';
import 'package:flutter/material.dart';

class MedicinesCardWidget extends StatelessWidget {
  final Medicine product; // Nhận một đối tượng Medicine từ danh sách

  // Khởi tạo ProductCard với đối tượng product
  MedicinesCardWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị ảnh sản phẩm nếu có
          product.anhSanPham.isNotEmpty
              ? Image.network(
            product.anhSanPham,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          )
              : Image.asset(
            'lib/assets/logo.png', // Ảnh mặc định nếu không có ảnh sản phẩm
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên sản phẩm
                Text(
                  product.tenSanPham,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                // Loại thuốc (ví dụ: Thuốc kê đơn, không kê đơn)
                Text(
                  product.loaiThuoc,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                // Giá bán sản phẩm (nếu có giá)
                Text(
                  'Giá: ${product.danhSachPhienBan.isNotEmpty ? product.danhSachPhienBan[0].giaBanQuyDoi : 'Liên hệ'} đ/${product.danhSachPhienBan[0].donViQuyDoi}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 7),
                // Nút chọn sản phẩm
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ProductSelectionBottomSheet(product: product),
                    );
                  },
                  child: Text(
                    'Chọn sản phẩm',
                    style: TextStyle(color: Colors.white), // Màu chữ trắng
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Màu nền của nút
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
