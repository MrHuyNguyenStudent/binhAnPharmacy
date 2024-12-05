import 'package:binh_an_pharmacy/screens/category_screen.dart';
import 'package:binh_an_pharmacy/screens/consultation_screen.dart';
import 'package:binh_an_pharmacy/screens/home_screen.dart';
import 'package:binh_an_pharmacy/screens/orders_screen.dart';
import 'package:binh_an_pharmacy/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBarWidget({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Danh mục',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Tư vấn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Đơn hàng',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Tài khoản',
        ),
      ],
      currentIndex: selectedIndex, // Vị trí tab hiện tại
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey, // Màu cho các item chưa được chọn
      showUnselectedLabels: true, // Hiển thị nhãn cho các item chưa chọn
      onTap: (index) {
        if (index == 0) {
          // Điều hướng đến CategoryScreen khi nhấn vào tab "Danh mục"
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
        else if (index == 1) {
          // Điều hướng đến CategoryScreen khi nhấn vào tab "Danh mục"
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryScreen()),
          );
        }
        else if (index == 2 ) {
          // Điều hướng đến CategoryScreen khi nhấn vào tab "Danh mục"
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConsultationScreen()),
          );
        }
        else if (index == 3 ) {
          // Điều hướng đến CategoryScreen khi nhấn vào tab "Danh mục"
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrdersScreen()),
          );
        }
        else if (index == 4) {
          // Nếu người dùng nhấn vào tab "Tài khoản", điều hướng đến ProfileScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        } else {
          // Nếu không phải tab "Tài khoản", gọi hàm onItemTapped từ widget cha
          onItemTapped(index);
        }
      }, // Gọi hàm khi nhấn vào tab
    );
  }
}
