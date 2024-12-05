import 'package:binh_an_pharmacy/models/medicine_model.dart';
import 'package:flutter/material.dart';

class MedicineDetailScreen extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailScreen({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.tenSanPham), // Tiêu đề hiển thị tên sản phẩm
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(medicine.anhSanPham), // Hình ảnh sản phẩm
              SizedBox(height: 16.0),
              Text(
                medicine.tenSanPham,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('Loại thuốc: ${medicine.loaiThuoc}'),
              Text('Mô tả: ${medicine.mota}'),
              Text('Đơn vị tính: ${medicine.donViTinhNhoNhat}'),
              Text('Hoạt chất chính: ${medicine.hoatChatChinh}'),
              Text('Hãng sản xuất: ${medicine.hangSanXuat}'),
              Text('Nước sản xuất: ${medicine.nuocSanXuat}'),
              Text('Quy cách đóng gói: ${medicine.quyCachDongGoi}'),
              Text('Cách dùng: ${medicine.duongDung}'),
              Text('Số đăng ký: ${medicine.soDangKy}'),
              Text('Mã vạch: ${medicine.maVach}'),
              // Thêm thông tin khác nếu cần
            ],
          ),
        ),
      ),
    );
  }
}