import 'package:binh_an_pharmacy/models/cart_item_model.dart';

class Order {
  final String id;
  final String khachHangId;
  final String? nhanVienId;
  final String? khuyenMaiId;
  final String hinhThucMuaHang;
  final String hinhThucThanhToan;
  final String trangThaiDonHang;
  final String trangThaiThanhToan;
  final double tongTien;
  final double thue;
  final double phiVanChuyen;
  final double thanhTien;
  final String ghiChu;
  final List<OrderItem> chiTietHoaDonBanHangs;
  final ShippingInfo giaoHang;
  final List<Timeline> timeline;
  final String createdBy;
  final String createdDate;
  final String modifiedBy;
  final String modifiedDate;

  Order({
    required this.id,
    required this.khachHangId,
    this.nhanVienId,
    this.khuyenMaiId,
    required this.hinhThucMuaHang,
    required this.hinhThucThanhToan,
    required this.trangThaiDonHang,
    required this.trangThaiThanhToan,
    required this.tongTien,
    required this.thue,
    required this.phiVanChuyen,
    required this.thanhTien,
    required this.ghiChu,
    required this.chiTietHoaDonBanHangs,
    required this.giaoHang,
    required this.timeline,
    required this.createdBy,
    required this.createdDate,
    required this.modifiedBy,
    required this.modifiedDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['chiTietHoaDonBanHangs'] as List;
    List<OrderItem> itemsList = list.map((i) => OrderItem.fromJson(i)).toList();

    var shippingInfo = json['giaoHang'] != null
        ? ShippingInfo.fromJson(json['giaoHang'])
        : ShippingInfo.empty();

    var timelineList = json['timeline'] as List;
    List<Timeline> timelineItems = timelineList.map((i) => Timeline.fromJson(i)).toList();

    return Order(
      id: json['id'],
      khachHangId: json['khachHangId'],
      nhanVienId: json['nhanVienId'],
      khuyenMaiId: json['khuyenMaiId'],
      hinhThucMuaHang: json['hinhThucMuaHang'],
      hinhThucThanhToan: json['hinhThucThanhToan'],
      trangThaiDonHang: json['trangThaiDonHang'],
      trangThaiThanhToan: json['trangThaiThanhToan'],
      tongTien: json['tongTien'].toDouble(),
      thue: json['thue'].toDouble(),
      phiVanChuyen: json['phiVanChuyen'].toDouble(),
      thanhTien: json['thanhTien'].toDouble(),
      ghiChu: json['ghiChu'],
      chiTietHoaDonBanHangs: itemsList,
      giaoHang: shippingInfo,
      timeline: timelineItems,
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }
}

class OrderItem {
  final String id;
  final String hoaDonId;
  final String phienBanSanPhamId;
  final int soLuong;
  final double gia;

  OrderItem({
    required this.id,
    required this.hoaDonId,
    required this.phienBanSanPhamId,
    required this.soLuong,
    required this.gia,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      hoaDonId: json['hoaDonId'],
      phienBanSanPhamId: json['phienBanSanPhamId'],
      soLuong: json['soLuong'],
      gia: json['gia'].toDouble(),
    );
  }
  // Phương thức chuyển đổi từ CartItem sang OrderItem
  factory OrderItem.fromCartItem(CartItem cartItem) {
    return OrderItem(
      id: cartItem.tenSanPham,
      hoaDonId: cartItem.khoiLuong,
      phienBanSanPhamId: cartItem.phienBanSanPhamId,
      soLuong: cartItem.soLuong,
      gia: cartItem.gia,
    );
  }
// Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'hoaDonId': hoaDonId,
      'phienBanSanPhamId': phienBanSanPhamId,
      'soLuong': soLuong,
      'gia': gia,
    };
  }
}

class ShippingInfo {
  final String id;
  final String maDonRutGon;
  final String tenNguoiGui;
  final String soDienThoaiNguoiGui;
  final String diaChiNguoiGui;
  final String quanHuyenNguoiGui;
  final String tinhThanhNguoiGui;
  final String tenNguoiNhan;
  final String soDienThoaiNguoiNhan;
  final String diaChiNguoiNhan;
  final String xaPhuongNguoiNhan;
  final String quanHuyenNguoiNhan;
  final String tinhThanhNguoiNhan;
  final String trackingNumber;
  final String thoiGianLayHangDuKien;
  final String thoiGianGiaoHangDuKien;

  ShippingInfo({
    required this.id,
    required this.maDonRutGon,
    required this.tenNguoiGui,
    required this.soDienThoaiNguoiGui,
    required this.diaChiNguoiGui,
    required this.quanHuyenNguoiGui,
    required this.tinhThanhNguoiGui,
    required this.tenNguoiNhan,
    required this.soDienThoaiNguoiNhan,
    required this.diaChiNguoiNhan,
    required this.xaPhuongNguoiNhan,
    required this.quanHuyenNguoiNhan,
    required this.tinhThanhNguoiNhan,
    required this.trackingNumber,
    required this.thoiGianLayHangDuKien,
    required this.thoiGianGiaoHangDuKien,
  });

  factory ShippingInfo.fromJson(Map<String, dynamic> json) {
    return ShippingInfo(
      id: json['id'],
      maDonRutGon: json['maDonRutGon'],
      tenNguoiGui: json['tenNguoiGui'],
      soDienThoaiNguoiGui: json['soDienThoaiNguoiGui'],
      diaChiNguoiGui: json['diaChiNguoiGui'],
      quanHuyenNguoiGui: json['quanHuyenNguoiGui'],
      tinhThanhNguoiGui: json['tinhThanhNguoiGui'],
      tenNguoiNhan: json['tenNguoiNhan'],
      soDienThoaiNguoiNhan: json['soDienThoaiNguoiNhan'],
      diaChiNguoiNhan: json['diaChiNguoiNhan'],
      xaPhuongNguoiNhan: json['xaPhuongNguoiNhan'],
      quanHuyenNguoiNhan: json['quanHuyenNguoiNhan'],
      tinhThanhNguoiNhan: json['tinhThanhNguoiNhan'],
      trackingNumber: json['trackingNumber'],
      thoiGianLayHangDuKien: json['thoiGianLayHangDuKien'],
      thoiGianGiaoHangDuKien: json['thoiGianGiaoHangDuKien'],
    );
  }

  // Factory method to create empty ShippingInfo (useful for fallback values)
  factory ShippingInfo.empty() {
    return ShippingInfo(
      id: '',
      maDonRutGon: '',
      tenNguoiGui: '',
      soDienThoaiNguoiGui: '',
      diaChiNguoiGui: '',
      quanHuyenNguoiGui: '',
      tinhThanhNguoiGui: '',
      tenNguoiNhan: '',
      soDienThoaiNguoiNhan: '',
      diaChiNguoiNhan: '',
      xaPhuongNguoiNhan: '',
      quanHuyenNguoiNhan: '',
      tinhThanhNguoiNhan: '',
      trackingNumber: '',
      thoiGianLayHangDuKien: '',
      thoiGianGiaoHangDuKien: '',
    );
  }
}

class GiaoHang {
  final String id;
  final String maDonRutGon;
  final String? tenNguoiNhan;
  final String? soDienThoaiNguoiNhan;
  final String? diaChiNguoiNhan;

  GiaoHang({
    required this.id,
    required this.maDonRutGon,
    this.tenNguoiNhan,
    this.soDienThoaiNguoiNhan,
    this.diaChiNguoiNhan,
  });

  factory GiaoHang.fromJson(Map<String, dynamic> json) {
    return GiaoHang(
      id: json['id'] ?? '', // Nếu 'id' null, trả về chuỗi rỗng
      maDonRutGon: json['maDonRutGon'] ?? '', // Nếu 'maDonRutGon' null, trả về chuỗi rỗng
      tenNguoiNhan: json['tenNguoiNhan'], // Có thể null
      soDienThoaiNguoiNhan: json['soDienThoaiNguoiNhan'], // Có thể null
      diaChiNguoiNhan: json['diaChiNguoiNhan'], // Có thể null
    );
  }
}

class HoaDon {
  final String id;
  final String khachHangId;
  final String hinhThucMuaHang;
  final String hinhThucThanhToan;
  final String trangThaiDonHang;
  final String trangThaiThanhToan;
  final double tongTien;
  final double phiVanChuyen;
  final double thanhTien;
  final GiaoHang? giaoHang;
  final String createdBy;
  final String createdDate;
  final String modifiedBy;
  final String modifiedDate;

  HoaDon({
    required this.id,
    required this.khachHangId,
    required this.hinhThucMuaHang,
    required this.hinhThucThanhToan,
    required this.trangThaiDonHang,
    required this.trangThaiThanhToan,
    required this.tongTien,
    required this.phiVanChuyen,
    required this.thanhTien,
    this.giaoHang,
    required this.createdBy,
    required this.createdDate,
    required this.modifiedBy,
    required this.modifiedDate,
  });

  factory HoaDon.fromJson(Map<String, dynamic> json) {
    return HoaDon(
      id: json['id'] ?? '', // Nếu 'id' null, trả về chuỗi rỗng
      khachHangId: json['khachHangId'] ?? '', // Nếu 'khachHangId' null, trả về chuỗi rỗng
      hinhThucMuaHang: json['hinhThucMuaHang'] ?? '', // Nếu 'hinhThucMuaHang' null, trả về chuỗi rỗng
      hinhThucThanhToan: json['hinhThucThanhToan'] ?? '', // Nếu 'hinhThucThanhToan' null, trả về chuỗi rỗng
      trangThaiDonHang: json['trangThaiDonHang'] ?? '', // Nếu 'trangThaiDonHang' null, trả về chuỗi rỗng
      trangThaiThanhToan: json['trangThaiThanhToan'] ?? '', // Nếu 'trangThaiThanhToan' null, trả về chuỗi rỗng
      tongTien: (json['tongTien'] as num?)?.toDouble() ?? 0.0, // Nếu 'tongTien' null, trả về 0.0
      phiVanChuyen: (json['phiVanChuyen'] as num?)?.toDouble() ?? 0.0, // Nếu 'phiVanChuyen' null, trả về 0.0
      thanhTien: (json['thanhTien'] as num?)?.toDouble() ?? 0.0, // Nếu 'thanhTien' null, trả về 0.0
      giaoHang: json['giaoHang'] != null ? GiaoHang.fromJson(json['giaoHang']) : null, // Nếu 'giaoHang' null, trả về null
      createdBy: json['createdBy'] ?? '', // Nếu 'createdBy' null, trả về chuỗi rỗng
      createdDate: json['createdDate'] ?? '', // Nếu 'createdDate' null, trả về chuỗi rỗng
      modifiedBy: json['modifiedBy'] ?? '', // Nếu 'modifiedBy' null, trả về chuỗi rỗng
      modifiedDate: json['modifiedDate'] ?? '', // Nếu 'modifiedDate' null, trả về chuỗi rỗng
    );
  }

  // Nếu API trả về danh sách hóa đơn, bạn có thể xử lý như sau:
  static List<HoaDon> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => HoaDon.fromJson(json)).toList();
  }
}


class Timeline {
  final int id;
  final String hoaDonBanHangOnlineId;
  final String status;
  final String thoiGian;
  final String? ghiChu;

  Timeline({
    required this.id,
    required this.hoaDonBanHangOnlineId,
    required this.status,
    required this.thoiGian,
    this.ghiChu,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      id: json['id'] ?? 0, // Nếu 'id' null, trả về 0
      hoaDonBanHangOnlineId: json['hoaDonBanHangOnlineId'] ?? '', // Nếu 'hoaDonBanHangOnlineId' null, trả về chuỗi rỗng
      status: json['status'] ?? '', // Nếu 'status' null, trả về chuỗi rỗng
      thoiGian: json['thoiGian'] ?? '', // Nếu 'thoiGian' null, trả về chuỗi rỗng
      ghiChu: json['ghiChu'], // Có thể null
    );
  }
}


// class Timeline {
//   final int id;
//   final String hoaDonBanHangOnlineId;
//   final String status;
//   final String thoiGian;
//   final String? ghiChu;
//
//
//   Timeline({
//     required this.id,
//     required this.hoaDonBanHangOnlineId,
//     required this.status,
//     required this.thoiGian,
//     this.ghiChu,
//   });
//
//   factory Timeline.fromJson(Map<String, dynamic> json) {
//     return Timeline(
//       id: json['id'],
//       hoaDonBanHangOnlineId: json['hoaDonBanHangOnlineId'],
//       status: json['status'],
//       thoiGian: json['thoiGian'],
//       ghiChu: json['ghiChu'],
//     );
//   }
// }
// Nếu API trả về danh sách hóa đơn, bạn có thể xử lý như sau: