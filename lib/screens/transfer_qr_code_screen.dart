// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
// class TransferQRCodeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Thông tin chuyển khoản (chuỗi thông tin chuyển khoản)
//     final String transferInfo = '''
//       Người thụ hưởng: Nguyễn Văn A
//       Ngân hàng: Vietcombank
//       Số tài khoản: 123456789
//       Số tiền: 1000000 VND
//       Nội dung chuyển khoản: Thanh toán đơn hàng #12345
//     ''';
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mã QR Chuyển Khoản'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               QrImageView(
//                 data: transferInfo, // Thông tin cần mã hóa
//                 version: QrVersions.auto,
//                 size: 200.0, // Kích thước QR Code
//                 eyeStyle: QrEyeStyle(
//                   eyeShape: QrEyeShape.square,
//                   color: Colors.black,
//                 ),
//                 dataModuleStyle: QrDataModuleStyle(
//                   dataModuleShape: QrDataModuleShape.square,
//                   color: Colors.black,
//                 ),
//               ),
//               Text(
//                 'Quét mã QR để thực hiện chuyển khoản',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 20),
//               ),
//               SizedBox(height: 20),
//               // Kiểm tra nếu dữ liệu quá dài
//                // Nếu không có dữ liệu, hiển thị loading
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
