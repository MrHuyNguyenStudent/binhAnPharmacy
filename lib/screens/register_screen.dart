import 'package:binh_an_pharmacy/screens/login_screen.dart';
import 'package:binh_an_pharmacy/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService(); // Tạo instance AuthService

  // Các controller để lấy dữ liệu từ TextField
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String selectedGender = "Nam";
  DateTime? selectedBirthDate;
  bool _isPasswordVisible = false;  // Biến theo dõi trạng thái hiện mật khẩu
  bool _isConfirmPasswordVisible = false;  // Biến theo dõi trạng thái hiện mật khẩu xác nhận
  // Hàm custom định dạng ngày
  String customDateFormat(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return "$year-$month-$day";
  }
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Ngày bắt đầu
      lastDate: DateTime.now(), // Không cho chọn ngày trong tương lai
    );
    if (pickedDate != null && pickedDate != selectedBirthDate) {
      setState(() {
        selectedBirthDate = pickedDate;
      });
    }
  }
  // Hàm xử lý đăng ký
  Future<void> _register() async {
    final username = usernameController.text;
    final email = emailController.text;
    final fullName = fullNameController.text;
    final phone = phoneController.text;
    final gender = genderController.text;
    final birthDate = selectedBirthDate != null
        ? customDateFormat(selectedBirthDate!)
        : null;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Kiểm tra mật khẩu và xác nhận mật khẩu
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mật khẩu và xác nhận mật khẩu không khớp")),
      );
      return;
    }
    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn ngày sinh")),
      );
      return;
    }
    try {
      // Gọi hàm đăng ký từ AuthService
      await _authService.registerCustomer(
        username: username,
        emailAddress: email,
        matKhau: password,
        hoTen: fullName,
        gioiTinh: gender=="Nam"?true:false,
        ngaySinh: birthDate,
        soDienThoai: phone
      );

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng ký thành công!")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (error) {
      // Hiển thị thông báo lỗi nếu đăng ký thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng ký thất bại: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.06),
              Text(
                "Đăng ký tài khoản",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              _buildTextField(
                controller: usernameController,
                labelText: "Tên đăng nhập",
                icon: Icons.person,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                controller: emailController,
                labelText: "Email",
                icon: Icons.email,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                controller: fullNameController,
                labelText: "Họ và Tên",
                icon: Icons.person,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                controller: phoneController,
                labelText: "Số điện thoại",
                icon: Icons.phone,
                inputType: TextInputType.phone,
              ),
              SizedBox(height: screenHeight * 0.02),

              // Dropdown giới tính
              Row(
                children: [
                  Icon(Icons.person, color: Colors.teal),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        labelText: "Giới tính",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: ["Nam", "Nữ"]
                          .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Chọn ngày sinh
              Row(
                children: [
                  Icon(Icons.date_range, color: Colors.teal),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectBirthDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: TextEditingController(
                            text: selectedBirthDate != null
                                ? customDateFormat(selectedBirthDate!)
                                : '',
                          ),
                          decoration: InputDecoration(
                            labelText: "Ngày sinh",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Mật khẩu
              _buildPasswordField(
                controller: passwordController,
                labelText: "Mật khẩu",
                icon: Icons.lock,
                isPasswordVisible: _isPasswordVisible,
                togglePasswordVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              // Xác nhận mật khẩu
              _buildPasswordField(
                controller: confirmPasswordController,
                labelText: "Xác nhận mật khẩu",
                icon: Icons.lock,
                isPasswordVisible: _isConfirmPasswordVisible,
                togglePasswordVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.03),

              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.2,
                    vertical: screenHeight * 0.015,
                  ),
                ),
                child: Text(
                  "Đăng ký",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã có tài khoản?',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Hàm tạo TextField mật khẩu với chức năng hiển thị mật khẩu
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required bool isPasswordVisible,
    required VoidCallback togglePasswordVisibility,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: !isPasswordVisible, // Sử dụng biến để ẩn/hiện mật khẩu
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.teal,
                ),
                onPressed: togglePasswordVisibility, // Chuyển đổi trạng thái
              ),
            ),
          ),
        ),
      ],
    );
  }
}