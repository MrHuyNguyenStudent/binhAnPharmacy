import 'package:binh_an_pharmacy/screens/login_screen.dart';
import 'package:binh_an_pharmacy/screens/phone_registration_screen.dart';
import 'package:binh_an_pharmacy/screens/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.05),
                child: Column(
                  children: [
                    Image.asset(
                      'lib/assets/logo1.png',
                      width: screenWidth * 0.6,
                      height: screenWidth * 0.6,
                    ),
                    Text(
                      'Binh An Pharmacy',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              Container(
                width: screenWidth * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Đăng ký ",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Login Button
              Container(
                width: screenWidth * 0.8,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.teal, width: 2),
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Đăng nhập",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Social Media Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialIconButton(Icons.facebook, screenWidth),
                  socialIconButton(Icons.telegram, screenWidth),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Social Login Text
            ],
          ),
        ),
      ),
    );
  }

  Widget socialIconButton(IconData icon, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: CircleAvatar(
        backgroundColor: Colors.teal,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
