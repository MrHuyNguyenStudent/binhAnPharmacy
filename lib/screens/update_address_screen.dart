import 'package:binh_an_pharmacy/models/address_model.dart';
import 'package:binh_an_pharmacy/screens/address_screen.dart';
import 'package:binh_an_pharmacy/services/address_service.dart';
import 'package:binh_an_pharmacy/widgets/address_districts_selectionbottom_sheet.dart';
import 'package:binh_an_pharmacy/widgets/address_selectionbottom_sheet.dart';
import 'package:binh_an_pharmacy/widgets/address_wards_selectionbottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateAddressScreen extends StatefulWidget {
  final DiaChiKhachHang? existingAddress; // Địa chỉ được truyền để chỉnh sửa

  const UpdateAddressScreen({Key? key, this.existingAddress}) : super(key: key);

  @override
  _UpdateAddressScreenState createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  int? diaChiKhachHangId;
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

  @override
  void initState() {
    super.initState();

    // Gán giá trị mặc định nếu existingAddress không null
    diaChiKhachHangId=widget.existingAddress?.id;
    hoTenController = TextEditingController(
        text: widget.existingAddress?.tenNguoiNhan ?? '');
    soDienThoaiController = TextEditingController(
        text: widget.existingAddress?.soDienThoaiNguoiNhan ?? '');
    soNhaController = TextEditingController(
        text: widget.existingAddress?.diaChiNguoiNhan ?? '');
    selectedWardName = widget.existingAddress?.xaPhuongNguoiNhan;
    selectedDistrictName = widget.existingAddress?.quanHuyenNguoiNhan;
    selectedProvinceName = widget.existingAddress?.tinhThanhNguoiNhan;
    macDinh = widget.existingAddress?.macDinh ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thay đổi địa chỉ'),
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
                try {
                  // Gọi phương thức cập nhật địa chỉ
                  await _diaChiService.updateAddress(
                    diaChiKhachHangId: diaChiKhachHangId!,
                    tenNguoiNhan: hoTenController.text,
                    soDienThoaiNguoiNhan: soDienThoaiController.text,
                    diaChiNguoiNhan: soNhaController.text,
                    xaPhuongNguoiNhan: selectedWardName!,
                    quanHuyenNguoiNhan: selectedDistrictName!,
                    tinhThanhNguoiNhan: selectedProvinceName!,
                    macDinh: macDinh,
                  );

                  // Kiểm tra nếu `diaChiKhachHangId` null (trường hợp không hợp lệ)
                  if (diaChiKhachHangId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Không thể cập nhật địa chỉ, vui lòng thử lại!')),
                    );
                    return;
                  }

                  // Xử lý khi địa chỉ được đặt làm mặc định
                  if (macDinh) {
                    bool success = await _diaChiService.setDefaultAddress(diaChiKhachHangId!);

                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Không thể cập nhật địa chỉ mặc định!')),
                      );
                      return;
                    }
                  }

                  // Nếu tất cả thành công, điều hướng về màn hình danh sách địa chỉ
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AddressScreen()),
                  );
                } catch (e) {
                  // Hiển thị thông báo lỗi nếu xảy ra ngoại lệ
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Có lỗi xảy ra: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 12), // Padding cho nút
              ),
              child: Text('Lưu thay đổi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}