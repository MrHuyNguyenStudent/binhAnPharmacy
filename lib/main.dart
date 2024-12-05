import 'package:binh_an_pharmacy/providers/address_provider.dart';
import 'package:binh_an_pharmacy/providers/cart_provider.dart';
import 'package:binh_an_pharmacy/screens/checkout_screen.dart';
import 'package:binh_an_pharmacy/screens/home_screen.dart';
import 'package:binh_an_pharmacy/screens/login_screen.dart';
import 'package:binh_an_pharmacy/screens/otp_verification_screen.dart';
import 'package:binh_an_pharmacy/screens/phone_registration_screen.dart';
import 'package:binh_an_pharmacy/screens/transfer_qr_code_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  // await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
      ],
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bình An Pharmacy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
      // home: TransferQRCodeScreen(),
      // home: PhoneRegistrationScreen(),
    );
  }
}

