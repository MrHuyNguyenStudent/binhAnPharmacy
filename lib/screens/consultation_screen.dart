import 'package:binh_an_pharmacy/screens/welcome_screen.dart';
import 'package:binh_an_pharmacy/services/user_service.dart';
import 'package:binh_an_pharmacy/widgets/bottom_nav_bar_widget.dart';
import 'package:flutter/material.dart';

class ConsultationScreen extends StatefulWidget {
  @override
  _ConsultationScreenState createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  bool _isLoggedIn = false;
  final TextEditingController _messageController = TextEditingController();
  List<String> _messages = []; // Danh sách chứa tin nhắn
  int _selectedIndex = 2; // Index của tab bar cho màn hình "Tư vấn"
  @override
  void initState() {
    super.initState();
    _checkLoginStatus;
  }
  // Hàm để xử lý việc gửi tin nhắn
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text); // Thêm tin nhắn vào danh sách
        _messageController.clear(); // Xóa nội dung khung soạn thảo sau khi gửi
      });
    }
  }

  // Hàm chuyển tab
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tư vấn'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: Alignment.centerLeft, // Tin nhắn từ người dùng
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(_messages[index]),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageComposer(), // Khu vực soạn tin nhắn
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        // isLoggedIn: isLoggedIn,
      ),
    );
  }

  // Widget khung soạn tin nhắn với nút gửi và gửi hình ảnh
  Widget _buildMessageComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: () {
              // Chức năng thêm hình ảnh (có thể tích hợp thư viện chọn hình ảnh)
              print("Thêm hình ảnh");
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration.collapsed(
                hintText: "Nhập tin nhắn...",
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage, // Gửi tin nhắn
          ),
        ],
      ),
    );
  }
}
