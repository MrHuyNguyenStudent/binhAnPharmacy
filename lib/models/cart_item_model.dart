class CartItem {
  final String phienBanSanPhamId;
  final String khachHangId;
  final String tenSanPham;
  final String khoiLuong;
  final String hinhAnh;
  final double gia;
  final int soLuong;
  bool selected; // Thêm thuộc tính selected
  CartItem({
    required this.phienBanSanPhamId,
    required this.khachHangId,
    required this.tenSanPham,
    required this.khoiLuong,
    required this.hinhAnh,
    required this.gia,
    required this.soLuong,
    this.selected = false, // Mặc định là false
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      phienBanSanPhamId: json['phienBanSanPhamId'],
      khachHangId: json['khachHangId'],
      tenSanPham: json['tenSanPham'],
      khoiLuong: json['khoiLuong'] ,
      hinhAnh: json['hinhAnh'],
      gia: (json['gia'] as num).toDouble(),
      soLuong: (json['soLuong'] as num).toInt(),
    );
  }
  //Phương thức copyWith
  CartItem copyWith({int? soLuong}) {
    return CartItem(
      phienBanSanPhamId: phienBanSanPhamId,
      khachHangId: khachHangId,
      tenSanPham: tenSanPham,
      khoiLuong: khoiLuong,
      hinhAnh: hinhAnh,
      gia: gia,
      soLuong: soLuong ?? this.soLuong,
      selected: selected,
    );
  }
}

