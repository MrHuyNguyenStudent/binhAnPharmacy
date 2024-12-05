class Category {
  final String id;
  final String tenDanhMuc;
  final String moTa;
  final String? createdBy;
  final DateTime createdDate;
  final DateTime? modifiedDate;
  final String? modifiedBy;

  Category({
    required this.id,
    required this.tenDanhMuc,
    required this.moTa,
    this.createdBy,
    required this.createdDate,
    this.modifiedDate,
    this.modifiedBy,
  });

  // Phương thức từ JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      tenDanhMuc: json['tenDanhMuc'],
      moTa: json['moTa'],
      createdBy: json['createdBy'],
      createdDate: DateTime.parse(json['createdDate']),
      modifiedDate: json['modifiedDate'] != null ? DateTime.parse(json['modifiedDate']) : null,
      modifiedBy: json['modifiedBy'],
    );
  }

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenDanhMuc': tenDanhMuc,
      'moTa': moTa,
      'createdBy': createdBy,
      'createdDate': createdDate.toIso8601String(),
      'modifiedDate': modifiedDate?.toIso8601String(),
      'modifiedBy': modifiedBy,
    };
  }
}
