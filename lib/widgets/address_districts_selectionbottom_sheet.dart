import 'package:binh_an_pharmacy/models/address_model.dart';
import 'package:binh_an_pharmacy/services/address_service.dart';
import 'package:flutter/material.dart';

class AddressDistrictsSelectionBottomSheet extends StatefulWidget {
  final String provinceId;
  final Function(District) onDistrictSelected;

  AddressDistrictsSelectionBottomSheet({required this.provinceId, required this.onDistrictSelected});

  @override
  _AddressDistrictsSelectionBottomSheetState createState() => _AddressDistrictsSelectionBottomSheetState();
}

class _AddressDistrictsSelectionBottomSheetState extends State<AddressDistrictsSelectionBottomSheet> {
  late Future<List<District>> _districtsFuture;

  @override
  void initState() {
    super.initState();
    _districtsFuture = DiaChiKhachHangService().fetchDistrictsByProvinceId(widget.provinceId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.75, // Chiếm 1/2 màn hình
      child: FutureBuilder<List<District>>(
        future: _districtsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi khi tải dữ liệu'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có quận/huyện nào'));
          } else {
            final districts = snapshot.data!;
            return ListView.builder(
              itemCount: districts.length,
              itemBuilder: (context, index) {
                final district = districts[index];
                return ListTile(
                  title: Text(district.districtName),
                  onTap: () {
                    widget.onDistrictSelected(district);  // Đóng bottom sheet khi chọn
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
