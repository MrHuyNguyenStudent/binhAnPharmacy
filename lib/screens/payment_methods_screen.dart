import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final String selectedMethod;

  const PaymentMethodsScreen({required this.selectedMethod});

  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  late String selectedPaymentMethod;

  final List<Map<String, dynamic>> paymentMethods = [
    {'label': 'Tiền mặt', 'icon': Icons.attach_money},
    {'label': 'Thẻ ATM', 'icon': Icons.atm},
  ];

  @override
  void initState() {
    super.initState();
    selectedPaymentMethod = widget.selectedMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phương thức thanh toán',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        children: paymentMethods.map((method) {
          final isSelected = selectedPaymentMethod == method['label'];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPaymentMethod = method['label'];
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.teal.withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.teal : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    method['icon'],
                    color: isSelected ? Colors.teal : Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      method['label'],
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.teal : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, selectedPaymentMethod);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Áp dụng',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
