import 'package:binh_an_pharmacy/models/customer_model.dart';
import 'package:binh_an_pharmacy/screens/profile_screen.dart';
import 'package:binh_an_pharmacy/services/user_service.dart';
import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatelessWidget {
  String formatDateTime(String dateTime) {
    // Chuyển chuỗi thời gian thành đối tượng DateTime
    DateTime parsedDate = DateTime.parse(dateTime);

    // Định dạng lại chuỗi theo mẫu mong muốn
    String formattedDate = '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';

    return formattedDate;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Customer>(
        future: UserService.getCustomerInfo(), // Gọi API để lấy dữ liệu
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị vòng xoay khi đang tải dữ liệu
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hiển thị lỗi nếu không tải được dữ liệu
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            // Hiển thị dữ liệu khi tải thành công
            final customer = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Họ và Tên', customer.hoTen),
                    const SizedBox(height: 16),
                    _buildInfoRow('Số điện thoại', customer.soDienThoai),
                    const SizedBox(height: 16),
                    _buildInfoRow('Ngày sinh', formatDateTime(customer.ngaySinh) ?? 'Chưa cập nhật'),
                    const SizedBox(height: 16),
                    _buildInfoRow('Giới tính', customer.gioiTinh? "Nam":"Nữ"),
                    const SizedBox(height: 16),
                    _buildInfoRow('Username', customer.username),
                    const SizedBox(height: 16),
                    _buildInfoRow('Email', customer.emailAddress ?? 'Chưa cập nhật'),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Lưu thay đổi',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Trường hợp không có dữ liệu
            return const Center(
              child: Text(
                'Không có dữ liệu',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
