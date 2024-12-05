import 'dart:convert';

import 'package:binh_an_pharmacy/models/address_model.dart';
import 'package:binh_an_pharmacy/models/cart_item_model.dart';
import 'package:binh_an_pharmacy/models/local_address_model.dart';
import 'package:binh_an_pharmacy/models/medicine_model.dart';
import 'package:binh_an_pharmacy/models/order.dart';
import 'package:binh_an_pharmacy/providers/cart_provider.dart';
import 'package:binh_an_pharmacy/screens/address_screen.dart';
import 'package:binh_an_pharmacy/screens/delivery_methods_screen.dart';
import 'package:binh_an_pharmacy/screens/discount_screen.dart';
import 'package:binh_an_pharmacy/screens/home_screen.dart';
import 'package:binh_an_pharmacy/screens/payment_methods_screen.dart';
import 'package:binh_an_pharmacy/services/address_service.dart';
import 'package:binh_an_pharmacy/services/medicine_service.dart';
import 'package:binh_an_pharmacy/services/medicine_version_service.dart';
import 'package:binh_an_pharmacy/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutNowScreen extends StatefulWidget {
  final String phienBanSanPhamId;
  final int quantity;
  CheckoutNowScreen({required this.phienBanSanPhamId, required this.quantity});
  @override
  _CheckoutNowScreenState createState() => _CheckoutNowScreenState();
}

class _CheckoutNowScreenState extends State<CheckoutNowScreen> {
  DiaChiKhachHang? defaultAddress;
  final DiaChiKhachHangService diaChiKhachHangService=DiaChiKhachHangService();
  double shippingFee = 0.0;
  late double subtotal;
  late double subtotalWeight;
  double code = 0.0;
  String selectedDiscount ='Chọn mã';
  String selectedPaymentMethod = 'Tiền mặt';
  String selectedDeliveryOption = 'none'; // Phương thức giao hàng mặc định
  String selectedDeliveryMethod ='Tiêu chuẩn'; // Phương thức mặc định
  final ApiOrdersService apiOrdersService = ApiOrdersService();
  late TextEditingController noteController;
  String paymentMethod='';
  late Future<Medicine> medicineFuture;
  late Future<PhienBan> phienBanFuture;
  @override
  void initState() {
    super.initState();
    noteController = TextEditingController();
    // Lấy địa chỉ mặc định khi màn hình được khởi tạo
    _loadDefaultAddress();
    medicineFuture = ApiMedicineServices().getFullMedicineInfo(widget.phienBanSanPhamId);
    phienBanFuture = ApiProductVersionService().getProductVersion(widget.phienBanSanPhamId);
    subtotal = 0.0;
    subtotalWeight=0.0;
  }
  // Hàm lấy địa chỉ mặc định
  Future<void> _loadDefaultAddress() async {
    try {
      DiaChiKhachHang? address = await diaChiKhachHangService.getDefaultAddress();
      if (address == null) {
        // Handle case where no address is found
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('chưa có địa chỉ giao hàng')));
      } else {
        setState(() {
          defaultAddress = address;
        });
        await _calculateShippingFee();// Tính lại phí giao hàng
      }
    } catch (e) {
      // Handle any network or API errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load address')));
    }
  }

  double parseKhoiLuong(String khoiLuong) {
    // Loại bỏ các ký tự không phải số và chỉ giữ lại phần số
    String numericValue = khoiLuong.replaceAll(RegExp(r'[^\d.]'), '');
    // Chuyển đổi giá trị chuỗi thành double
    return double.tryParse(numericValue) ?? 0.0; // Trả về 0.0 nếu không thể chuyển đổi
  }
// Hàm xử lý thay đổi địa chỉ
  Future<void> _updateAddress(DiaChiKhachHang newAddress) async {
    setState(() {
      defaultAddress = newAddress; // Cập nhật địa chỉ mặc định mới
    });
    await _calculateShippingFee(); // Tính lại phí giao hàng
  }
  // Hàm tính phí giao hàng
  Future<void> _calculateShippingFee() async {
    if (defaultAddress == null) return;

    subtotalWeight = subtotalWeight / 1000; // Chuyển khối lượng sang kg
    ShippingRequest shippingRequest = ShippingRequest(
      province: '${defaultAddress?.tinhThanhNguoiNhan}',
      district: '${defaultAddress?.quanHuyenNguoiNhan}',
      weight: '${subtotalWeight}',
      deliverOption: selectedDeliveryOption,
    );

    try {
      ShippingResponse response =
      await diaChiKhachHangService.calculateShippingFee(shippingRequest);
      setState(() {
        shippingFee = response.fee.toDouble();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to calculate shipping fee')));
    }
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
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
  String _payment(String selectedPaymentMethod){
    if(selectedPaymentMethod=='Tiền mặt'){
      paymentMethod='Thanh toán trả sau khi nhận hàng';
    }else{
      paymentMethod='Thanh toán trả trước';
    }
    return paymentMethod;
  }
  // Hàm gọi API khi đặt hàng
  Future<void> placeOrder(String phienBanSanPhamId, int soLuong) async {
    String note = noteController.text;
    try {
      await apiOrdersService.addOrderNow(
        defaultAddress!.tenNguoiNhan,defaultAddress!.soDienThoaiNguoiNhan,defaultAddress!.diaChiNguoiNhan,defaultAddress!.xaPhuongNguoiNhan,defaultAddress!.quanHuyenNguoiNhan,defaultAddress!.tinhThanhNguoiNhan,
        paymentMethod,
        note,
        selectedDiscount,
        phienBanSanPhamId,
        soLuong,
      );
      print('ten nguoi nhan ${defaultAddress!.tenNguoiNhan}');
      // Sau khi đặt hàng thành công, có thể chuyển đến màn hình khác hoặc thông báo thành công
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Đặt hàng thành công!"),
          content: Text("Đơn hàng của bạn đang chờ xác nhận."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false, // Loại bỏ toàn bộ các màn hình trước đó
                );
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      // Nếu có lỗi trong quá trình đặt hàng
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Lỗi!"),
          content: Text("Đã có lỗi xảy ra khi đặt hàng. Xin vui lòng thử lại."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    if (defaultAddress == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Mua ngay')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // Tính tổng giá tiền của các sản phẩm được chọn
    final double totalAmount = (subtotal - code)*1.1 + shippingFee;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mua ngay'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Cột bên trái (chiếm 4 phần)
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái cho cột bên trái
                      children: [
                        // Tiêu đề "Địa chỉ giao hàng"
                        Text(
                          'Địa chỉ giao hàng',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2), // Khoảng cách giữa tiêu đề và phần địa chỉ

                        // Hiển thị địa chỉ
                        buildAddressSection(defaultAddress!),
                      ],
                    ),
                  ),

                  // Cột bên phải (chiếm 1 phần), chứa button thay đổi
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
                      crossAxisAlignment: CrossAxisAlignment.end, // Căn giữa theo chiều ngang
                      children: [
                        // Hàng trên: Hiển thị button thay đổi
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios_outlined, size: 25, color: Colors.grey),
                          onPressed: () async {
                            final selectedAddressId = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressScreen(
                                  currentAddressId: defaultAddress?.id, // Gửi ID địa chỉ hiện tại (nếu có)
                                ),
                              ),
                            );

                            if (selectedAddressId != null) {
                              setState(() {
                                _updateAddress(selectedAddressId);
                              });
                            }
                          },
                          iconSize: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Hiển thị các sản phẩm đã được chọn
              Divider(),
              if (widget.phienBanSanPhamId.isEmpty)
                Text('Chưa có sản phẩm nào được chọn')
              else
                Column(
                  children: [
                    FutureBuilder<Medicine>(
                      future: medicineFuture,
                      builder: (context, medicineSnapshot) {
                        if (medicineSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (medicineSnapshot.hasError) {
                          return Center(child: Text('Lỗi: ${medicineSnapshot.error}'));
                        } else if (!medicineSnapshot.hasData) {
                          return Center(child: Text('Không có dữ liệu'));
                        }

                        // Lấy thông tin từ medicineSnapshot
                        final medicine = medicineSnapshot.data!;

                        return FutureBuilder<PhienBan>(
                          future: phienBanFuture,
                          builder: (context, phienBanSnapshot) {
                            if (phienBanSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (phienBanSnapshot.hasError) {
                              return Center(child: Text('Lỗi: ${phienBanSnapshot.error}'));
                            } else if (!phienBanSnapshot.hasData) {
                              return Center(child: Text('Không có dữ liệu'));
                            }

                            // Lấy thông tin từ phienBanSnapshot
                            final phienBan = phienBanSnapshot.data!;
                            // Trì hoãn việc cập nhật subtotal và subtotalWeight cho đến khi widget được dựng
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  subtotal = phienBan.giaBanQuyDoi * widget.quantity;
                                  subtotalWeight = parseKhoiLuong(phienBan.khoiLuong) * widget.quantity;
                                });
                              }
                            });
                            // Sử dụng hàm _buildProductItem để hiển thị thông tin sản phẩm
                            return _buildProductItem(
                              imageUrl: medicine.anhSanPham,
                              name: phienBan.tenQuyDoi,
                              price: '${formatCurrency(phienBan.giaBanQuyDoi)} đ',
                              quantity: widget.quantity,
                            );
                          },
                        );
                      },
                    ),
                  ]
                ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,  // Căn chỉnh theo chiều ngang
                crossAxisAlignment: CrossAxisAlignment.center,  // Căn chỉnh theo chiều dọc
                children: [
                  Text(
                    'Ghi chú',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),  // Khoảng cách giữa Text và TextField
                  Expanded(
                    child: TextField(
                      controller: noteController,
                      textAlign: TextAlign.right,
                      maxLines: 1, // Giới hạn số dòng nhập là 1
                      decoration: InputDecoration(
                        hintText: 'Nhập ghi chú ở đây',
                        hintStyle: TextStyle(fontSize: 10,color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping_outlined, size: 20, color: Colors.teal),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 7,
                    child: Text(
                      'Phương thức vận chuyển',
                      style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextButton(
                      onPressed: () async {
                        // Mở DeliveryMethodsScreen và nhận về phương thức giao hàng
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeliveryMethodsScreen(
                              selectedMethod: selectedDeliveryMethod,
                            ),
                          ),
                        );

                        if (result != null ) {
                          setState(() {
                            selectedDeliveryMethod = result;
                            if(selectedDeliveryMethod == "Nhanh"){
                              selectedDeliveryOption='xteam';
                            }else{
                              selectedDeliveryOption='none';
                            }
                          });
                          await _calculateShippingFee(); // Tính phí khi thay đổi phương thức giao hàng
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,  // Canh giữa nội dung
                        children: [
                          Text(
                            selectedDeliveryMethod, //cần hiển thị phương thức vận chuyển được chọn
                            style: TextStyle(fontSize: 12, color: Colors.teal),  // Màu chữ
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 16,  // Kích thước icon
                            color: Colors.grey,  // Màu icon
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined, size: 20, color: Colors.teal),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 7,
                    child: Text(
                      'Phương thức thanh toán',
                      style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextButton(
                      onPressed: () async {
                        final result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentMethodsScreen(
                              selectedMethod: selectedPaymentMethod,
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            selectedPaymentMethod = result;
                            _payment(selectedPaymentMethod);// Cập nhật phương thức
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,  // Canh giữa nội dung
                        children: [
                          Text(
                            selectedPaymentMethod,
                            style: TextStyle(fontSize: 12, color: Colors.teal),  // Màu chữ
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 16,  // Kích thước icon
                            color: Colors.grey,  // Màu icon
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              Divider(),
              // Phần còn lại của CheckoutScreen (giống như bạn đã có)
              Text(
                'Chi tiết thanh toán',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              // Ví dụ phần thanh toán chi tiết
              _buildPaymentDetailRow('Tạm tính', '${formatCurrency(subtotal)} đ'),
              _buildPaymentDetailRow('Phí vận chuyển', '${formatCurrency(shippingFee)} đ'),
              _buildPaymentDetailRow('Giảm giá ưu đãi', '${formatCurrency(code)} đ'),
              _buildPaymentDetailRow('VAT', '10%'),
              Divider(),
              _buildPaymentDetailRow('Thành tiền', '${formatCurrency(totalAmount)} đ', isBold: true, color: Colors.red),
              SizedBox(height: 13),

              // Điều khoản và Mã khuyến mãi
              Row(
                children: [
                  Checkbox(value: true, onChanged: (value) {},activeColor: Colors.teal,),
                  Expanded(
                    child: Text(
                      'Bằng cách tích vào ô chọn, bạn đã đồng ý với các điều khoản Bình An Pharmacy',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 13),
            ],
          ),
        ),
      ),
      // Bottom navigation bar with promo code, total, and place order
      bottomNavigationBar: Container(
        height: 135, // Chiều cao tổng thể của Bottom Navigation Bar
        decoration: BoxDecoration(
          color: Colors.white, // Màu nền của bottom navigation
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, -2), // Đổ bóng lên trên
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phần trên: Mã khuyến mãi
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                height: 48, // Chiều cao cố định cho phần trên
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.loyalty, size: 16, color: Colors.grey[700]),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 7,
                      child: Text(
                        'Mã khuyến mãi',
                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        onPressed: () async {
                          final result = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiscountScreen(
                                selectedDiscount: selectedDiscount,
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              selectedDiscount = result; // Cập nhật phương thức
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,  // Canh giữa nội dung
                          children: [
                            Text(
                              selectedDiscount,
                              style: TextStyle(fontSize: 12, color: Colors.teal),  // Màu chữ
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,  // Kích thước icon
                              color: Colors.grey,  // Màu icon
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: Colors.grey[300]),

              // Phần dưới: Tổng tiền và Đặt hàng
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                height: 80, // Chiều cao cố định cho phần dưới
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2, // Phần "Tổng tiền" chiếm 2 phần
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Tổng tiền',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '${formatCurrency(totalAmount)} đ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 1, // Phần "Đặt hàng" chiếm 1 phần
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed:(){
                              placeOrder(widget.phienBanSanPhamId,widget.quantity);
                            },
                            child: Text(
                              'Đặt hàng',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              minimumSize: Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem({
    required String imageUrl,
    required String name,
    required String price,
    required int quantity,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          Text('x$quantity'),
        ],
      ),
    );
  }
  Widget buildAddressSection(DiaChiKhachHang defaultAddress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,  // Căn lề trái cho tất cả các Text widget
      children: [
        // Hiển thị tên người nhận và số điện thoại
        Text(
          '${defaultAddress.tenNguoiNhan}, ${defaultAddress.soDienThoaiNguoiNhan}',
          style: TextStyle(fontSize: 11), // Có thể thay đổi font size tùy ý
        ),
        SizedBox(height: 1), // Khoảng cách giữa các dòng
        // Hiển thị địa chỉ chi tiết
        Text(
          '${defaultAddress.diaChiNguoiNhan}, ${defaultAddress.xaPhuongNguoiNhan}, ${defaultAddress.quanHuyenNguoiNhan}, ${defaultAddress.tinhThanhNguoiNhan}',
          style: TextStyle(fontSize: 11), // Có thể thay đổi font size tùy ý
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPaymentDetailRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
