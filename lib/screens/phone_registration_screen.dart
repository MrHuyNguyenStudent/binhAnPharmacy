// import 'package:binh_an_pharmacy/screens/otp_verification_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class PhoneRegistrationScreen extends StatefulWidget {
//   @override
//   _PhoneRegistrationScreenState createState() => _PhoneRegistrationScreenState();
// }
//
// class _PhoneRegistrationScreenState extends State<PhoneRegistrationScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Hàm gửi mã OTP
//   Future<void> _sendOtp() async {
//     String phoneNumber = _phoneController.text.trim();
//
//     if (phoneNumber.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Vui lòng nhập số điện thoại')),
//       );
//       return;
//     }
//
//     // Xác thực số điện thoại và gửi OTP
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // Nếu Firebase tự động xác thực OTP
//         await _auth.signInWithCredential(credential);
//         // Tiến hành chuyển sang màn hình chính hoặc xử lý tiếp
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi: ${e.message}')),
//         );
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         // Sau khi gửi OTP thành công, chuyển sang màn hình nhập OTP
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => OtpVerificationScreen(phoneNumber: phoneNumber, verificationId: verificationId),
//           ),
//         );
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         // Xử lý khi mã OTP hết thời gian
//       },
//     );
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
//                   const SizedBox(height: 16),
//
//                   // Tiêu đề
//                   const Text(
//                     "Đăng ký",
//                     style: TextStyle(
//                       fontSize: 28, // Tăng kích thước tiêu đề
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // Hướng dẫn
//                   const Text(
//                     "Nhập số điện thoại bạn muốn đăng ký",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                     ),
//                   ),
//
//                   const SizedBox(height: 24), // Tăng khoảng cách trước phần nhập số điện thoại
//
//                   // Ô nhập số điện thoại
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50], // Nền màu nhạt cho ô nhập
//                       borderRadius: BorderRadius.circular(30.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8.0,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: _phoneController,
//                       keyboardType: TextInputType.phone,
//                       style: const TextStyle(fontSize: 16, color: Colors.black),
//                       decoration: const InputDecoration(
//                         hintText: 'Số điện thoại',
//                         border: InputBorder.none,
//                         prefixIcon: Icon(Icons.phone, color: Colors.blue),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 32), // Tăng khoảng cách giữa ô nhập và nút
//
//                   // Nút tiếp tục
//                   ElevatedButton(
//                     onPressed: _sendOtp,
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
//                       "Tiếp tục",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
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
