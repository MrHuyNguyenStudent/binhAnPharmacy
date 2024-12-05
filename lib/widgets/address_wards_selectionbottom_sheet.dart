import 'package:binh_an_pharmacy/models/address_model.dart';
import 'package:binh_an_pharmacy/services/address_service.dart';
import 'package:flutter/material.dart';

class AddressWardSelectionBottomSheet extends StatelessWidget {
  final String districtId;
  final Function(Ward) onWardSelected;

  AddressWardSelectionBottomSheet({required this.districtId, required this.onWardSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.75, // Chiếm 1/2 màn hình
      child: FutureBuilder<List<Ward>>(
        future: DiaChiKhachHangService().fetchWardsByDistrictId(districtId),  // Lấy dữ liệu phường/xã từ API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi khi tải dữ liệu phường/xã'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có phường/xã nào'));
          } else {
            final wards = snapshot.data!;
            return ListView.builder(
              itemCount: wards.length,
              itemBuilder: (context, index) {
                final ward = wards[index];
                return ListTile(
                  title: Text(ward.wardName),
                  onTap: () {
                    onWardSelected(ward);  // Đóng bottom sheet và chọn phường/xã
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
