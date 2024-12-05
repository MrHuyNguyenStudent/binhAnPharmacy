class ShippingRequest {
  final String province;
  final String district;
  final String weight;
  final String deliverOption;

  ShippingRequest({
    required this.province,
    required this.district,
    required this.weight,
    required this.deliverOption,
  });

  // Phương thức toJson để chuyển đối tượng ShippingRequest thành JSON
  Map<String, dynamic> toJson() {
    return {
      'pick_province': 'Hồ Chí Minh',  // Các giá trị cố định
      'pick_district': 'Quận Gò Vấp',  // Các giá trị cố định
      'province': province,  // Lấy từ biến province
      'district': district,  // Lấy từ biến district
      'weight': weight,  // Lấy từ biến weight
      'deliver_option': deliverOption,  // Lấy từ biến deliverOption
    };
  }
}

class ShippingResponse {
  final int fee;  // Trường này chứa giá trị fee trả về từ API

  ShippingResponse({required this.fee});

  factory ShippingResponse.fromJson(Map<String, dynamic> json) {
    // Trích xuất giá trị fee từ phần "fee"
    return ShippingResponse(
      fee: json['fee']['fee'],
    );
  }
}
