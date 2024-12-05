import 'package:binh_an_pharmacy/screens/update_address_screen.dart';
import 'package:binh_an_pharmacy/services/address_service.dart';
import 'package:flutter/material.dart';
import 'package:binh_an_pharmacy/models/address_model.dart';
import 'package:binh_an_pharmacy/screens/add_address_screen.dart';

class AddressItem extends StatelessWidget {
  final DiaChiKhachHang address;
  final int? selectedAddressId;
  final ValueChanged<int> onAddressSelected;
  final ValueChanged<int> onAddressDeleted;

  const AddressItem({
    Key? key,
    required this.address,
    required this.selectedAddressId,
    required this.onAddressSelected,
    required this.onAddressDeleted,
  }) : super(key: key);

  // Hàm xóa địa chỉ sử dụng DiaChiKhachHangService
  Future<void> deleteAddress(int diaChiKhachHangId) async {
    try {
      // Gọi service để xóa địa chỉ
      await DiaChiKhachHangService.deleteAddress(diaChiKhachHangId); // Sửa lại gọi đúng phương thức từ service

      // Sau khi xóa thành công, gọi callback để thông báo với widget cha
      onAddressDeleted(diaChiKhachHangId);
    } catch (e) {
      print('Lỗi khi xóa địa chỉ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          // Cột 1: Radio
          Expanded(
            flex: 1,
            child: Transform.scale(
              scale: 0.8, // Giảm kích thước của Radio
              child: Radio<int>(
                value: address.id, // ID của địa chỉ hiện tại
                groupValue: selectedAddressId, // ID của địa chỉ được chọn
                onChanged: (value) {
                  if (value != null) onAddressSelected(value);
                },
              ),
            ),
          ),

          // Cột 2: Thông tin địa chỉ
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.tenNguoiNhan,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(address.soDienThoaiNguoiNhan),
                Text(
                  '${address.diaChiNguoiNhan}, ${address.xaPhuongNguoiNhan}, '
                      '${address.quanHuyenNguoiNhan}, ${address.tinhThanhNguoiNhan}',
                ),
              ],
            ),
          ),

          // Cột 3: Icon edit và delete
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các icon
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.teal),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateAddressScreen(
                          existingAddress: address, // Truyền địa chỉ để chỉnh sửa
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () {
                    // Gọi hàm xóa được truyền từ cha
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xác nhận'),
                        content: const Text('Bạn có chắc muốn xóa địa chỉ này?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context), // Đóng dialog
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Đóng dialog
                              deleteAddress(address.id); // Gọi hàm xóa
                            },
                            child: const Text('Xóa'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
