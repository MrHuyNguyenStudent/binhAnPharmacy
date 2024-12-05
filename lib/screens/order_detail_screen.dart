import 'package:binh_an_pharmacy/services/medicine_service.dart';
import 'package:binh_an_pharmacy/services/medicine_version_service.dart';
import 'package:binh_an_pharmacy/services/orders_service.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  final String id;

  OrderDetailScreen({required this.id});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final ApiOrdersService apiService = ApiOrdersService();
  final ApiProductVersionService apiProductVersionService=ApiProductVersionService();
  final ApiMedicineServices apiMedicineServices=ApiMedicineServices();
  Map<String, dynamic>? hoaDonDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHoaDonDetail();
  }

  // Hàm lấy chi tiết hóa đơn
  Future<void> fetchHoaDonDetail() async {
    try {
      final data = await apiService.fetchHoaDonDetail(widget.id);
      setState(() {
        hoaDonDetail = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể tải chi tiết hóa đơn')));
    }
  }
  // // Hàm lấy thông tin phiên bản sản phẩm
  // Future<String> fetchProductVersion(String phienBanSanPhamId) async {
  //   try {
  //     final phienBan = await apiProductVersionService.getProductVersion(phienBanSanPhamId);
  //     return phienBan.tenQuyDoi; // Lấy tên phiên bản (hoặc bất kỳ thuộc tính nào bạn cần)
  //   } catch (e) {
  //     return 'Không thể lấy thông tin phiên bản';
  //   }
  // }
  Future<Map<String, dynamic>> fetchProductVersion(String phienBanSanPhamId) async {
    try {
      // Lấy thông tin phiên bản sản phẩm
      final phienBan = await apiProductVersionService.getProductVersion(phienBanSanPhamId);

      // Lấy thông tin đầy đủ sản phẩm, bao gồm hình ảnh
      final medicine = await apiMedicineServices.getFullMedicineInfo(phienBanSanPhamId);

      // Trả về tên quy đổi và hình ảnh
      return {
        'tenQuyDoi': phienBan.tenQuyDoi,
        'anhSanPham': medicine.anhSanPham,
      };
    } catch (e) {
      // Xử lý lỗi và trả về giá trị mặc định
      return {
        'tenQuyDoi': 'Không thể lấy thông tin phiên bản',
        'anhSanPham': null,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết Hóa Đơn'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hoaDonDetail == null
          ? Center(child: Text('Không có dữ liệu'))
          : ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Trang thái:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Hình Thức Mua Hàng: ${hoaDonDetail!['hinhThucMuaHang']}'),
          Text('Hình Thức Thanh Toán: ${hoaDonDetail!['hinhThucThanhToan']}'),
          Text('Trạng Thái Đơn Hàng: ${hoaDonDetail!['trangThaiDonHang']}'),
          Text('Trạng Thái Thanh Toán: ${hoaDonDetail!['trangThaiThanhToan']}'),
          Text('Ghi Chú: ${hoaDonDetail!['ghiChu']}'),
          // Thêm các phần khác của hóa đơn
          Divider(),
          Text('Chi Tiết Sản Phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: hoaDonDetail!['chiTietHoaDonBanHangs'].length,
            itemBuilder: (context, index) {
              final product = hoaDonDetail!['chiTietHoaDonBanHangs'][index];
              return FutureBuilder<Map<String, dynamic>>(
                future: fetchProductVersion(product['phienBanSanPhamId']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Đang tải...'),
                    );
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return ListTile(
                      leading: Icon(Icons.error),
                      title: Text('Không thể tải thông tin'),
                    );
                  } else {
                    final productData = snapshot.data!;
                    return ListTile(
                      leading: productData['anhSanPham'] != null
                          ? Image.network(
                        productData['anhSanPham'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.image_not_supported),
                      title: Text(productData['tenQuyDoi']),
                      subtitle: Text('Số lượng: ${product['soLuong']} - Đơn giá: ${product['gia']}'),
                    );
                  }
                },
              );
            },
          ),

          Divider(),
          Text('Chi phí:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Tổng Tiền: ${hoaDonDetail!['tongTien']}'),
          Text('Thuế: ${hoaDonDetail!['thue']}'),
          Text('Phí Vận Chuyển: ${hoaDonDetail!['phiVanChuyen']}'),
          Text('Thành Tiền: ${hoaDonDetail!['thanhTien']}'),
          Divider(),
          Text('Giao Hàng:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Tên Người Nhận: ${hoaDonDetail?['giaoHang']?['tenNguoiNhan'] ?? ''}'),
          Text('Số Điện Thoại: ${hoaDonDetail!['giaoHang']['soDienThoaiNguoiNhan']}'),
          Text('Địa Chỉ: ${hoaDonDetail!['giaoHang']['diaChiNguoiNhan']}'),
          Text('Thời Gian Giao Hàng: ${hoaDonDetail!['giaoHang']['thoiGianGiaoHangDuKien']}'),
          // Hiển thị thông tin khác của giao hàng
        ],
      ),
    );
  }
}
