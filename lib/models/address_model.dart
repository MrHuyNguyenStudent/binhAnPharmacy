class DiaChiKhachHang {
  final int id;
  final String khachHangId;
  final String tenNguoiNhan;
  final String soDienThoaiNguoiNhan;
  final String diaChiNguoiNhan;
  final String xaPhuongNguoiNhan;
  final String quanHuyenNguoiNhan;
  final String tinhThanhNguoiNhan;
  final bool macDinh;
  final DateTime createdDate;
  bool selected;
  DiaChiKhachHang({
    required this.id,
    required this.khachHangId,
    required this.tenNguoiNhan,
    required this.soDienThoaiNguoiNhan,
    required this.diaChiNguoiNhan,
    required this.xaPhuongNguoiNhan,
    required this.quanHuyenNguoiNhan,
    required this.tinhThanhNguoiNhan,
    required this.macDinh,
    required this.createdDate,
    this.selected = false,
  });

  factory DiaChiKhachHang.fromJson(Map<String, dynamic> json) {
    return DiaChiKhachHang(
      id: json['id'],
      khachHangId: json['khachHangId'],
      tenNguoiNhan: json['tenNguoiNhan'],
      soDienThoaiNguoiNhan: json['soDienThoaiNguoiNhan'],
      diaChiNguoiNhan: json['diaChiNguoiNhan'],
      xaPhuongNguoiNhan: json['xaPhuongNguoiNhan'],
      quanHuyenNguoiNhan: json['quanHuyenNguoiNhan'],
      tinhThanhNguoiNhan: json['tinhThanhNguoiNhan'],
      macDinh: json['macDinh'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'khachHangId': khachHangId,
      'tenNguoiNhan': tenNguoiNhan,
      'soDienThoaiNguoiNhan': soDienThoaiNguoiNhan,
      'diaChiNguoiNhan': diaChiNguoiNhan,
      'xaPhuongNguoiNhan': xaPhuongNguoiNhan,
      'quanHuyenNguoiNhan': quanHuyenNguoiNhan,
      'tinhThanhNguoiNhan': tinhThanhNguoiNhan,
      'macDinh': macDinh,
      'createdDate': createdDate,
    };
  }
}
// Định nghĩa model cho Province
class Province {
  final String provinceId;
  final String provinceName;
  final String provinceType;

  Province({
    required this.provinceId,
    required this.provinceName,
    required this.provinceType,
  });

  // Factory method để parse từ JSON
  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      provinceId: json['province_id'],
      provinceName: json['province_name'],
      provinceType: json['province_type'],
    );
  }
}
// Lớp District để lưu thông tin quận huyện
class District {
  final String districtId;
  final String districtName;
  final String districtType;
  final double? lat;
  final double? lng;
  final String provinceId;

  District({
    required this.districtId,
    required this.districtName,
    required this.districtType,
    this.lat,
    this.lng,
    required this.provinceId,
  });

  // Phương thức từ JSON sang đối tượng District
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      districtId: json['district_id'],
      districtName: json['district_name'],
      districtType: json['district_type'],
      lat: json['lat'] != null ? json['lat'] : null,
      lng: json['lng'] != null ? json['lng'] : null,
      provinceId: json['province_id'],
    );
  }
}
class Ward {
  final String wardId;
  final String wardName;
  final String wardType;

  Ward({
    required this.wardId,
    required this.wardName,
    required this.wardType,
  });

  // Phương thức từ JSON sang đối tượng Ward
  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      wardId: json['ward_id'],
      wardName: json['ward_name'],
      wardType: json['ward_type'],
    );
  }
}


