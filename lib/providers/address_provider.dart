import 'package:flutter/material.dart';
import 'package:binh_an_pharmacy/models/address_model.dart';
import 'package:binh_an_pharmacy/services/address_service.dart';

class AddressProvider with ChangeNotifier {
  final DiaChiKhachHangService _addressService = DiaChiKhachHangService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<DiaChiKhachHang> _addresses = [];
  List<DiaChiKhachHang> get addresses => _addresses;

  int? _selectedAddressId;
  int? get selectedAddressId => _selectedAddressId;

  void selectAddress(int addressId) {
    _selectedAddressId = addressId;
    notifyListeners();
  }

  Future<void> fetchAddresses() async {
    try {
      _isLoading = true;
      notifyListeners();
      _addresses = await _addressService.fetchDiaChiKhachHang();
    } catch (e) {
      print('Lỗi khi lấy danh sách địa chỉ: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Phương thức để lấy địa chỉ mặc định
  DiaChiKhachHang? get defaultAddress {
    return _addresses.firstWhere(
          (address) => address.macDinh,
      orElse: () => DiaChiKhachHang(
        id: -1, // Giá trị không hợp lệ để chỉ rằng không có địa chỉ mặc định
        khachHangId: '',
        tenNguoiNhan: '',
        soDienThoaiNguoiNhan: '',
        diaChiNguoiNhan: '',
        xaPhuongNguoiNhan: '',
        quanHuyenNguoiNhan: '',
        tinhThanhNguoiNhan: '',
        macDinh: false, // Đảm bảo không phải địa chỉ mặc định
        createdDate: DateTime.now(),
        selected: false,
      ),
    );
  }
  // Phương thức xóa địa chỉ
  Future<void> deleteAddress(int diaChiKhachHangId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi phương thức xóa địa chỉ từ DiaChiKhachHangService
      await DiaChiKhachHangService.deleteAddress(diaChiKhachHangId);

      // Sau khi xóa thành công, cập nhật lại danh sách địa chỉ
      _addresses.removeWhere((address) => address.id == diaChiKhachHangId);

      // Cập nhật lại UI
      notifyListeners();

      print('Đã xóa địa chỉ thành công');
    } catch (e) {
      print('Lỗi khi xóa địa chỉ: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
