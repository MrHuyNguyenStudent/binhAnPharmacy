import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget { // Kế thừa PreferredSizeWidget
  final int selectedIndex;
  final Function(int) onTap;
  final TabController tabController;

  CustomTabBar({
    required this.selectedIndex,
    required this.onTap,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: TabBar(
        controller: tabController,
        labelColor: Colors.teal,
        unselectedLabelColor: Colors.black,
        indicatorColor: Colors.teal,
        onTap: onTap,
        isScrollable: true,
        tabs: const [
          Tab(text: "Hoàn thành "),
          Tab(text: "Chờ xác nhận "),
          Tab(text: "Đã xác nhận "),
          Tab(text: "Đang chuẩn bị hàng "),
          Tab(text: "Đã hủy "),
          Tab(text: "Đang giao "),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Trả về kích thước cần thiết
}
