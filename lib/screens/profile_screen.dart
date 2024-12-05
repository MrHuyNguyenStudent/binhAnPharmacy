import 'package:binh_an_pharmacy/models/customer_model.dart';
import 'package:binh_an_pharmacy/screens/address_screen.dart';
import 'package:binh_an_pharmacy/screens/change_password_screen.dart';
import 'package:binh_an_pharmacy/screens/home_screen.dart';
import 'package:binh_an_pharmacy/screens/personalInfo_screen.dart';
import 'package:binh_an_pharmacy/screens/welcome_screen.dart';
import 'package:binh_an_pharmacy/services/user_service.dart';
import 'package:binh_an_pharmacy/widgets/bottom_nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false;
  int _selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Kiểm tra trạng thái đăng nhập
  void _checkLoginStatus() async {
    String? token = await UserService.getAccessToken();  // Lấy token từ SharedPreferences
    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } else {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }
  void _info(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PersonalInfoScreen()),
    );
  }

  void _changeps(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
    );
  }
void _listaddress(){
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AddressScreen()),
  );
}
  // Hàm xử lý đăng xuất
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Xóa toàn bộ dữ liệu trong SharedPreferences

    // Chuyển hướng về màn hình WelcomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF1F5FE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Container(
              height: screenHeight * 0.35,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Color(0xFF029789),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Back button and Edit Profile button
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.05,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        Text(
                          'Thông tin tài khoản',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Sửa',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profile picture, name and ID
                  CircleAvatar(
                    radius: screenWidth * 0.12,
                    backgroundImage: AssetImage('lib/assets/profile.png'),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: screenWidth * 0.03,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.add, color: Colors.teal, size: screenWidth * 0.04),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  FutureBuilder<Customer>(
                    future: UserService.getCustomerInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Lỗi: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Column(
                          children: [
                            Text(
                              snapshot.data!.hoTen,
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "TichDiem: ${snapshot.data!.tichDiem}, Rank: ${snapshot.data!.rankKhachHang}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text('Không có dữ liệu');
                      }
                    },
                  ),
                ],
              ),
            ),
            // Options list
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              child: Column(
                children: [
                  _buildOption(context, Icons.person, "Thông tin cá nhân"),
                  _buildOption(context, Icons.password, "Thay đổi mật khẩu"),
                  _buildOption(context, Icons.map, "Sổ địa chỉ"),
                  _buildOption(context, Icons.logout, "Đăng xuất"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (title == "Đăng xuất") {
          _logout();  // Gọi hàm logout khi chọn "Đăng xuất"
        }
        if (title == "Thông tin cá nhân") {
          _info();  // Gọi hàm logout khi chọn "Đăng xuất"
        }
        if (title == "Thay đổi mật khẩu") {
          _changeps();  // Gọi hàm logout khi chọn "Đăng xuất"
        }
        if (title == "Sổ địa chỉ") {
          _listaddress();  // Gọi hàm logout khi chọn "Đăng xuất"
        }


      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF029789), size: screenWidth * 0.06),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: Colors.grey, size: screenWidth * 0.05),
          ],
        ),
      ),
    );
  }
}
