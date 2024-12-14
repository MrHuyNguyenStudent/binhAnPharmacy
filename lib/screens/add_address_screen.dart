
import 'package:binh_an_pharmacy/models/address_model.dart';
import 'package:binh_an_pharmacy/screens/address_screen.dart';
import 'package:binh_an_pharmacy/services/address_service.dart';
import 'package:binh_an_pharmacy/widgets/address_districts_selectionbottom_sheet.dart';
import 'package:binh_an_pharmacy/widgets/address_selectionbottom_sheet.dart';
import 'package:binh_an_pharmacy/widgets/address_wards_selectionbottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddAddressScreen extends StatefulWidget {

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  String? selectedProvinceName;
  String? selectedDistrictName;
  String? selectedProvinceId;
  String? selectedWardName;  // Lưu phường/xã đã chọn
  String? selectedDistrictId;// Thêm biến để lưu provinceId
// Biến macDinh để lưu trạng thái
  bool macDinh = false;
  TextEditingController soNhaController = TextEditingController();
  TextEditingController soDienThoaiController = TextEditingController();
  TextEditingController hoTenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DiaChiKhachHangService _diaChiService = DiaChiKhachHangService();
  // Hàm mở AddressSelectionBottomSheet
  void _openAddressSelectionBottomSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return AddressSelectionBottomSheet(
          onSelected: (province) {
            setState(() {
              selectedProvinceName = province.provinceName;
              selectedProvinceId = province.provinceId; // Cập nhật provinceId khi người dùng chọn tỉnh
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _openDistrictSelectionBottomSheet(String provinceId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return AddressDistrictsSelectionBottomSheet(
          provinceId: provinceId,
          onDistrictSelected: (district) {
            setState(() {
              selectedDistrictName = district.districtName;
              selectedDistrictId = district.districtId;// Lưu district vào selectedDistrictName
            });
            Navigator.pop(context); // Đóng bottom sheet sau khi chọn quận/huyện
          },
        );
      },
    );
  }
// Phương thức mở bottom sheet cho phường/xã
  void _openWardSelectionBottomSheet(String districtId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return AddressWardSelectionBottomSheet(
          districtId: districtId,
          onWardSelected: (ward) {
            setState(() {
              selectedWardName = ward.wardName;  // Lưu tên phường/xã đã chọn
            });
            Navigator.pop(context);  // Đóng bottom sheet
          },
        );
      },
    );
  }
  bool isPhoneNumberValid(String phoneNumber) {
    final phoneRegex = RegExp(r"^0\d{9}$");
    return phoneRegex.hasMatch(phoneNumber);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm địa chỉ mới'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Họ và tên',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: hoTenController,
              decoration: InputDecoration(
                hintText: 'Nhập họ và tên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Số điện thoại
            Text(
              'Số điện thoại',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: soDienThoaiController,
              decoration: InputDecoration(
                hintText: 'Nhập số điện thoại',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Địa chỉ
            Text(
              'Địa chỉ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            TextField(
              onTap: _openAddressSelectionBottomSheet, // Mở AddressSelectionBottomSheet khi chọn vào TextField
              readOnly: true,
              decoration: InputDecoration(
                hintText: selectedProvinceName ?? 'Chọn Tỉnh/Thành Phố',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onTap: selectedProvinceId == null
                  ? null // Nếu chưa chọn tỉnh, không cho chọn quận
                  : () {
                if (selectedProvinceId != null) {
                  _openDistrictSelectionBottomSheet(selectedProvinceId!);
                }
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: selectedDistrictName ?? 'Chọn Quận/Huyện',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onTap: selectedDistrictId == null
                  ? null // Nếu chưa chọn quận, không cho chọn phường/xã
                  : () {
                if (selectedDistrictId != null) {
                  _openWardSelectionBottomSheet(selectedDistrictId!);  // Mở bottom sheet phường/xã
                }
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: selectedWardName ?? 'Chọn Phường/Xã',  // Hiển thị phường/xã đã chọn
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: soNhaController,
              decoration: InputDecoration(
                hintText: 'Nhập số nhà, tên đường',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Đặt làm địa chỉ mặc định
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Đặt làm địa chỉ mặc định'),
                Switch(
                  value: macDinh,
                  activeColor: Colors.teal,  // Màu khi switch bật (on)
                  inactiveThumbColor: Colors.grey,  // Màu khi switch tắt (off)
                  onChanged: (value) {
                    setState(() {
                      macDinh = value;  // Cập nhật giá trị macDinh khi switch thay đổi
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (soDienThoaiController.text.isEmpty || !isPhoneNumberValid(soDienThoaiController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Số điện thoại không hợp lệ!')),
                  );
                  return;
                }
                try {
                  // Gọi phương thức thêm địa chỉ mới
                  int? diaChiKhachHangId = await _diaChiService.addNewAddress(
                    hoTenController.text,
                    soDienThoaiController.text,
                    soNhaController.text,
                    selectedWardName!,
                    selectedDistrictName!,
                    selectedProvinceName!,
                    macDinh,
                  );

                  if (diaChiKhachHangId == null) {
                    // Nếu không thêm được địa chỉ, hiển thị thông báo lỗi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Không thể thêm địa chỉ mới, vui lòng thử lại!')),
                    );
                    return;
                  }

                  if (macDinh == true) {
                    // Nếu địa chỉ được đặt làm mặc định, gọi API cập nhật
                    bool success = await _diaChiService.setDefaultAddress(diaChiKhachHangId);

                    if (!success) {
                      // Hiển thị thông báo lỗi nếu không thể cập nhật địa chỉ mặc định
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Không thể cập nhật địa chỉ mặc định!')),
                      );
                    }
                  }

                  // Điều hướng về màn hình AddressScreen sau khi hoàn tất
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AddressScreen()),
                  );
                } catch (e) {
                  // Bắt lỗi và hiển thị thông báo
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Có lỗi xảy ra: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Màu nền của nút
              ),
              child: Text('Thêm Địa Chỉ',
                style: TextStyle(fontSize: 13, color: Colors.white,fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}