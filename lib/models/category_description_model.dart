class CategoryDescription {
  final String id;
  final String tenDanhMuc;
  final String moTa;

  CategoryDescription({
    required this.id,
    required this.tenDanhMuc,
    required this.moTa,
  });

  factory CategoryDescription.fromJson(Map<String, dynamic> json) {
    return CategoryDescription(
      id: json['id'],
      tenDanhMuc: json['tenDanhMuc'],
      moTa: json['moTa'],
    );
  }
}
