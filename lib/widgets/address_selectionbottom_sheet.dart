import 'package:binh_an_pharmacy/models/address_model.dart';
import 'package:binh_an_pharmacy/services/address_service.dart';
import 'package:flutter/material.dart';

class AddressSelectionBottomSheet extends StatelessWidget {
  final Function(Province) onSelected;

  AddressSelectionBottomSheet({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Province>>(
      future: DiaChiKhachHangService().fetchProvinces(), // Dùng hàm fetchProvinces để lấy danh sách tỉnh/thành phố
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải dữ liệu: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có dữ liệu tỉnh/thành phố.'));
        }

        final provinces = snapshot.data!;
        return Container(
          height: MediaQuery.of(context).size.height * 0.75, // Chiếm 3/4 chiều cao màn hình
          child: ListView.builder(
            itemCount: provinces.length,
            itemBuilder: (context, index) {
              final province = provinces[index];
              return ListTile(
                title: Text(province.provinceName),
                onTap: () {
                  // Gọi hàm onSelected và chỉ trả về provinceName
                  onSelected(province);
                },
              );
            },
          ),
        );
      },
    );
  }
}
