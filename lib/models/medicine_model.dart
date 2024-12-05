class Medicine {
  final String id;
  final String maThuoc;
  final String tenSanPham;
  final String maVach;
  final String soDangKy;
  final String donViTinhNhoNhat;
  final String loaiThuoc;
  final String? mota;
  final String hoatChatChinh;
  final String hangSanXuat;
  final String nuocSanXuat;
  final String quyCachDongGoi;
  final String duongDung;
  final String anhSanPham;
  final bool trangThaiBan;
  final String danhMucId;
  final List<PhienBan> danhSachPhienBan;

  Medicine({
    required this.id,
    required this.maThuoc,
    required this.tenSanPham,
    required this.maVach,
    required this.soDangKy,
    required this.donViTinhNhoNhat,
    required this.loaiThuoc,
    this.mota,
    required this.hoatChatChinh,
    required this.hangSanXuat,
    required this.nuocSanXuat,
    required this.quyCachDongGoi,
    required this.duongDung,
    required this.anhSanPham,
    required this.trangThaiBan,
    required this.danhMucId,
    required this.danhSachPhienBan,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    var danhSachPhienBanJson = json['danhSachPhienBan'] as List;
    List<PhienBan> danhSachPhienBan = danhSachPhienBanJson.map((i) => PhienBan.fromJson(i)).toList();

    return Medicine(
      id: json['id'],
      maThuoc: json['maThuoc'],
      tenSanPham: json['tenSanPham'],
      maVach: json['maVach'],
      soDangKy: json['soDangKy'],
      donViTinhNhoNhat: json['donViTinhNhoNhat'],
      loaiThuoc: json['loaiThuoc'],
      mota: json['mota'],
      hoatChatChinh: json['hoatChatChinh'],
      hangSanXuat: json['hangSanXuat'],
      nuocSanXuat: json['nuocSanXuat'],
      quyCachDongGoi: json['quyCachDongGoi'],
      duongDung: json['duongDung'],
      anhSanPham: json['anhSanPham'],
      trangThaiBan: json['trangThaiBan'],
      danhMucId: json['danhMucId'],
      danhSachPhienBan: danhSachPhienBan,
    );
  }
}

class PhienBan {
  final String id;
  final String tenQuyDoi;
  final String donViQuyDoi;
  final double soLuong; // Sử dụng double thay vì int nếu số lượng là số thực
  final String maVach;
  final String maSanPham;
  final String khoiLuong;
  final double giaNhapQuyDoi; // Chuyển sang double
  final double giaBanQuyDoi; // Chuyển sang double
  final bool trangThaiBan;
  final String sanPhamId;

  PhienBan({
    required this.id,
    required this.tenQuyDoi,
    required this.donViQuyDoi,
    required this.soLuong,
    required this.maVach,
    required this.maSanPham,
    required this.khoiLuong,
    required this.giaNhapQuyDoi,
    required this.giaBanQuyDoi,
    required this.trangThaiBan,
    required this.sanPhamId,
  });

  factory PhienBan.fromJson(Map<String, dynamic> json) {
    return PhienBan(
      id: json['id'],
      tenQuyDoi: json['tenQuyDoi'],
      donViQuyDoi: json['donViQuyDoi'],
      soLuong: (json['soLuong'] as num).toDouble(), // Chuyển từ num sang double
      maVach: json['maVach'],
      maSanPham: json['maSanPham'],
      khoiLuong: json['khoiLuong'],
      giaNhapQuyDoi: (json['giaNhapQuyDoi'] as num).toDouble(), // Chuyển từ num sang double
      giaBanQuyDoi: (json['giaBanQuyDoi'] as num).toDouble(), // Chuyển từ num sang double
      trangThaiBan: json['trangThaiBan'],
      sanPhamId: json['sanPhamId'],
    );
  }
}
