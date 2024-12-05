// import 'package:binh_an_pharmacy/screens/register_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class OtpVerificationScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String verificationId;
//
//   OtpVerificationScreen({required this.phoneNumber, required this.verificationId});
//
//   @override
//   _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
// }
//
// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final TextEditingController _otpController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Hàm xác thực OTP
//   Future<void> _verifyOtp() async {
//     String otp = _otpController.text.trim();
//
//     if (otp.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Vui lòng nhập mã OTP')),
//       );
//       return;
//     }
//
//     try {
//       // Tạo PhoneAuthCredential với verificationId và OTP
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: widget.verificationId,
//         smsCode: otp,
//       );
//
//       // Đăng nhập với credential (OTP)
//       UserCredential userCredential = await _auth.signInWithCredential(credential);
//
//       // Kiểm tra nếu đăng nhập thành công
//       if (userCredential.user != null) {
//         // Chuyển đến màn hình đăng ký thông tin người dùng kèm theo số điện thoại
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => RegisterScreen(phoneNumber: widget.phoneNumber),
//           ),
//         );
//       }
//     } catch (e) {
//       // Hiển thị lỗi nếu OTP không chính xác hoặc có lỗi khác
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi: ${e.toString()}')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           color: Colors.white, // Nền tổng màu trắng
//           height: screenHeight, // Chiều cao toàn màn hình để căn giữa
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Logo
//                   Image.asset(
//                     'lib/assets/logo1.png',
//                     width: screenWidth * 0.5, // Giảm kích thước logo
//                     height: screenHeight * 0.3,
//                   ),
//
//                   const SizedBox(height: 16), // Tăng khoảng cách giữa logo và tiêu đề
//
//                   // Tiêu đề
//                   const Text(
//                     "Đăng ký",
//                     style: TextStyle(
//                       fontSize: 28,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // Hướng dẫn
//                   const Text(
//                     "Nhập mã OTP được gửi đến số điện thoại của bạn",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                     ),
//                   ),
//
//                   const SizedBox(height: 24), // Tăng khoảng cách trước phần nhập OTP
//
//                   // Ô nhập OTP
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: List.generate(6, (index) {
//                       return SizedBox(
//                         width: 50,
//                         child: TextField(
//                           controller: _otpController,
//                           textAlign: TextAlign.center,
//                           keyboardType: TextInputType.number,
//                           maxLength: 1,
//                           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                           decoration: InputDecoration(
//                             counterText: "", // Loại bỏ bộ đếm ký tự
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                               borderSide: const BorderSide(color: Colors.blue),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                               borderSide: const BorderSide(color: Colors.blue, width: 2.0),
//                             ),
//                           ),
//                           onChanged: (value) {
//                             if (value.isNotEmpty && index < 5) {
//                               FocusScope.of(context).nextFocus();
//                             } else if (value.isEmpty && index > 0) {
//                               FocusScope.of(context).previousFocus();
//                             }
//                           },
//                         ),
//                       );
//                     }),
//                   ),
//
//                   const SizedBox(height: 32), // Tăng khoảng cách giữa ô nhập và nút
//
//                   // Nút xác nhận
//                   ElevatedButton(
//                     onPressed: _verifyOtp,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 32.0,
//                         vertical: 16.0,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50.0),
//                       ),
//                     ),
//                     child: const Text(
//                       "Xác nhận",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // Nút gửi lại mã OTP
//                   TextButton(
//                     onPressed: () {
//                       // Xử lý gửi lại mã OTP
//                     },
//                     child: const Text(
//                       "Gửi lại mã OTP",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
