import 'dart:convert';
import 'package:binh_an_pharmacy/api/url_api.dart';
import 'package:binh_an_pharmacy/models/medicine_model.dart';
import 'package:binh_an_pharmacy/screens/cart_screen.dart';
import 'package:binh_an_pharmacy/screens/order_detail_screen.dart';
import 'package:binh_an_pharmacy/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:binh_an_pharmacy/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class OrderItemWidget extends StatelessWidget {
  final HoaDon hoaDon;

  const OrderItemWidget({required this.hoaDon});

  // Hàm lấy chi tiết hóa đơn từ API
  Future<Map<String, dynamic>> fetchfirstProductVersion(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('${APIConfig.baseURL}/hoadonbanhang/GetHoaDonBanHangOnlineByID?hoaDonId=$orderId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Truy cập vào danh sách chi tiết hóa đơn và lấy "phienBanSanPhamId" từ phần tử đầu tiên
        final String phienBanSanPhamId = data['chiTietHoaDonBanHangs'][0]['phienBanSanPhamId'];
        // Lấy thông tin phiên bản sản phẩm
        final phienBan = await getProductVersion(phienBanSanPhamId);

        // Lấy thông tin đầy đủ sản phẩm, bao gồm hình ảnh
        final medicine = await getFullMedicineInfo(phienBanSanPhamId);

        // Trả về tên quy đổi và hình ảnh
        return {
          'tenQuyDoi': phienBan.tenQuyDoi,
          'anhSanPham': medicine.anhSanPham,
        };
      }else {
        throw Exception('Không thể tải chi tiết hóa đơn');
      }
    } catch (e) {
      // Xử lý lỗi và trả về giá trị mặc định
      return {
        'tenQuyDoi': 'Không thể lấy thông tin phiên bản',
        'anhSanPham': null,
      };
    }
  }
  // Phương thức mua lại sản phẩm trong hóa đơn
  Future<void> handleReorder(BuildContext context, String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('${APIConfig.baseURL}/hoadonbanhang/GetHoaDonBanHangOnlineByID?hoaDonId=$orderId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        for (var item in data['chiTietHoaDonBanHangs']) {
          final String phienBanSanPhamId = item['phienBanSanPhamId']; // Lấy mã phiên bản sản phẩm
          final int soLuong = item['soLuong']; // Lấy số lượng sản phẩm

          // Lấy thông tin khách hàng từ SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? customerId = prefs.getString('customerId');

          if (customerId == null) {
            print('Không tìm thấy thông tin khách hàng!');
            return;
          }

          // Thêm sản phẩm vào giỏ hàng
          bool success = await addProductToCart(
            khachHangId: customerId,
            phienBanSanPhamId: phienBanSanPhamId,
            soLuong: soLuong,
          );
          // Sau khi thêm thành công, điều hướng quay lại màn hình trước và tải lại
          Navigator.pop(context); // Quay lại màn hình trước
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()), // Điều hướng lại vào màn hình giỏ hàng
          );
        }
      }
    } catch (error) {
      print('Lỗi khi mua lại: $error');
    }
  }
  Future<PhienBan> getProductVersion(String id) async {
    final response = await http.get(Uri.parse('${APIConfig
        .baseURL}/phienbansanpham/GetPhienBanSanPhamByPhienBanId/$id'));

    if (response.statusCode == 200) {
      return PhienBan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể lấy thông tin phiên bản sản phẩm');
    }
  }
  // Xác nhận đơn
  Future<void> xacNhanDon(BuildContext context,String orderId) async {
    final response = await http.post(Uri.parse('${APIConfig
        .baseURL}/hoadonbanhang/XacNhanDaGiaoHang?hoaDonId=$orderId'));

    if (response.statusCode == 200) {
      print('Xác nhận đã nhận hàng thành công!');
    } else {
      throw Exception('Xác nhận không thành công');
    }
  }
  //Hủy đơn
  Future<void> huyDonHang(BuildContext context,String orderId) async {
    final response = await http.post(Uri.parse('${APIConfig.baseURL}/hoadonbanhang/XacNhanHuyDonHang?hoaDonId=$orderId'));

    if (response.statusCode == 200) {
      print('Đơn hàng đã được hủy thành công!');
    } else {
      throw Exception('Chỉ đơn hàng ở trang thái Chờ xác nhận, Đã xác nhận, Đang chuẩn bị mới có thể hủy');
    }
  }
  // Fetch all medicines
  Future<Medicine> getMedicines(String id) async {
    final url = Uri.parse('${APIConfig.baseURL}/sanpham/GetSanPham/$id');

    try {
      final response = await http.get(
        url,
        headers: {
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Medicine.fromJson(json);
      } else {
        throw Exception(
            'Failed to load medicine. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching medicine: $error');
    }
  }
  Future<Medicine> getFullMedicineInfo(String phienBanId) async {
    try {
      // Bước 1: Lấy thông tin phiên bản sản phẩm
      PhienBan phienBan = await getProductVersion(phienBanId);

      // Bước 2: Sử dụng maSanPham để lấy thông tin chi tiết sản phẩm
      Medicine medicine = await getMedicines(phienBan.maSanPham);

      return medicine;
    } catch (error) {
      throw Exception('Không thể lấy thông tin sản phẩm đầy đủ: $error');
    }
  }
  // Phương thức thêm sản phẩm vào giỏ hàng
  Future<bool> addProductToCart({
    required String khachHangId,
    required String phienBanSanPhamId,
    required int soLuong,
  }) async {
    // Lấy token từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Access token not found');
    }

    // URL API
    final url = Uri.parse('${APIConfig.baseURL}/giohang/ThemSanPhamVaoGioHang');

    // Tạo body yêu cầu
    final Map<String, dynamic> body = {
      "khachHangId": khachHangId,
      "phienBanSanPhamId": phienBanSanPhamId,
      "soLuong": soLuong,
    };

    // Gửi yêu cầu POST
    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'token': token,
      },
      body: json.encode(body),
    );

    // Xử lý phản hồi
    if (response.statusCode == 200) {
      print('Sản phẩm đã được thêm vào giỏ hàng thành công!');
      return true;
    } else {
      print('Thêm sản phẩm vào giỏ hàng thất bại: ${response.body}');
      throw Exception('Failed to add product to cart');
    }
  }
  String formatDateTime(String dateTime) {
    // Chuyển chuỗi thời gian thành đối tượng DateTime
    DateTime parsedDate = DateTime.parse(dateTime);

    // Chuyển sang giờ UTC+7 (thêm 7 giờ)
    DateTime utcPlus7 = parsedDate.toUtc().add(Duration(hours: 7));

    // Định dạng lại chuỗi theo mẫu mong muốn (giờ:phút ngày/tháng/năm)
    String formattedDate = '${utcPlus7.hour}:${utcPlus7.minute.toString().padLeft(2, '0')} '
        '${utcPlus7.day}/${utcPlus7.month}/${utcPlus7.year}';

    return formattedDate;
  }


  //format
  String formatCurrency(double value) {
    // Chuyển giá trị thành chuỗi
    String valueStr = value.toStringAsFixed(2);

    // Tách phần nguyên và phần thập phân
    List<String> parts = valueStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    // Thêm dấu phẩy vào phần nguyên
    String formattedInteger = '';
    int count = 0;

    // Duyệt qua phần nguyên từ phải qua trái và thêm dấu phẩy mỗi ba chữ số
    for (int i = integerPart.length - 1; i >= 0; i--) {
      count++;
      formattedInteger = integerPart[i] + formattedInteger;
      if (count % 3 == 0 && i != 0) {
        formattedInteger = ',' + formattedInteger;
      }
    }

    // Nối phần nguyên và phần thập phân
    return formattedInteger + '.' + decimalPart;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hàng 1: Trạng thái đơn hàng và thời gian
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: hoaDon.hinhThucMuaHang == "Online"
                          ? Colors.green.shade100
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Mua ${hoaDon.hinhThucMuaHang}",
                      style: TextStyle(
                        color: hoaDon.hinhThucMuaHang == "Tại quầy"
                            ? Colors.green
                            : Colors.blue,
                      ),
                    ),
                  ),
                  Text(
                    '${formatDateTime(hoaDon.createdDate)}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Divider(),
              // Hàng 2: Thông tin thuốc
              FutureBuilder<Map<String, dynamic>>(
                future: fetchfirstProductVersion(hoaDon.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Lỗi: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final String tenQuyDoi = data['tenQuyDoi'];
                    final String? anhSanPham = data['anhSanPham'];

                    return Row(
                      children: [
                        // Hình ảnh sản phẩm
                        if (anhSanPham != null)
                          Image.network(
                            anhSanPham,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          )
                        else
                          const Icon(Icons.image_not_supported),
                        const SizedBox(width: 8),
                        // Thông tin tên phiên bản sản phẩm
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tenQuyDoi,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text("Không có dữ liệu");
                  }
                },
              ),
              const SizedBox(height: 8),
              Divider(),
              // Hàng 3: Thành tiền
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Thành tiền: ${formatCurrency(hoaDon.thanhTien)}"),
                ],
              ),
              Divider(),
              // Thêm nút xem chi tiết
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nút "Xem chi tiết"
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(id: hoaDon.id),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white54, // Nền màu xanh
                      foregroundColor: Colors.blue, // Chữ màu trắng
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Bo góc nút
                      ),
                    ),
                    child: const Text('Xem chi tiết'),
                  ),

                  // Kiểm tra trạng thái đơn hàng
                  if (hoaDon.trangThaiDonHang == "Đã giao hàng"||hoaDon.trangThaiDonHang == "Hoàn thành"||hoaDon.trangThaiDonHang == "Đã hủy")
                    TextButton(
                      onPressed: () {
                        handleReorder(context,hoaDon.id);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.teal, // Nền màu xanh
                        foregroundColor: Colors.white, // Chữ màu trắng
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Bo góc nút
                        ),
                      ),
                      child: const Text(
                        'Mua lại',
                        style: TextStyle(fontWeight: FontWeight.bold), // Chữ đậm
                      ),
                    ),
                  if (hoaDon.trangThaiDonHang == "Đang vận chuyển")
                    TextButton(
                      onPressed: () {
                        xacNhanDon(context,hoaDon.id);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.teal, // Nền màu xanh
                        foregroundColor: Colors.white, // Chữ màu trắng
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Bo góc nút
                        ),
                      ),
                      child: const Text(
                        'Đã nhận hàng',
                        style: TextStyle(fontWeight: FontWeight.bold), // Chữ đậm
                      ),
                    ),
                  if (hoaDon.trangThaiDonHang == "Chờ xác nhận"||hoaDon.trangThaiDonHang == "Đã xác nhận"||hoaDon.trangThaiDonHang == "Đang chuẩn bị")
                    TextButton(
                      onPressed: () {
                        huyDonHang(context,hoaDon.id);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.teal, // Nền màu xanh
                        foregroundColor: Colors.white, // Chữ màu trắng
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Bo góc nút
                        ),
                      ),
                      child: const Text(
                        'Hủy đơn',
                        style: TextStyle(fontWeight: FontWeight.bold), // Chữ đậm
                      ),
                    ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}