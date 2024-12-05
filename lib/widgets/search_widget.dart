import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onSearch;

  SearchWidget({this.controller, this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSearch,  // Gọi hàm onSearch khi người dùng nhấn Enter
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.qr_code_scanner), // Có thể thay đổi hoặc bỏ
        hintText: "Tìm kiếm thuốc",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
