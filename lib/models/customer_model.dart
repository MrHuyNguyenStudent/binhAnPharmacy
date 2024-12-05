class Customer {
  final String id;
  final String username;
  final String emailAddress;
  final String hoTen;
  final String diaChi;
  final String thanhPho;
  final bool gioiTinh;
  final String ngaySinh;
  final String soDienThoai;
  final String quyen;
  final double tichDiem;
  final String rankKhachHang;

  Customer({
    required this.id,
    required this.username,
    required this.emailAddress,
    required this.hoTen,
    required this.diaChi,
    required this.thanhPho,
    required this.gioiTinh,
    required this.ngaySinh,
    required this.soDienThoai,
    required this.quyen,
    required this.tichDiem,
    required this.rankKhachHang,
  });
  // Chuyển JSON sang đối tượng Customer
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      username: json['username'],
      emailAddress: json['emailAddress'],
      hoTen: json['hoTen'],
      diaChi: json['diaChi'],
      thanhPho: json['thanhPho'],
      gioiTinh: json['gioiTinh'],
      ngaySinh: json['ngaySinh'],
      soDienThoai: json['soDienThoai'],
      quyen: json['quyen'],
      tichDiem: json['tichDiem'],
      rankKhachHang: json['rankKhachHang'],
    );
  }
}
