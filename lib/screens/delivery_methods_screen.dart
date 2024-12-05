import 'package:flutter/material.dart';

class DeliveryMethodsScreen extends StatefulWidget {
  final String selectedMethod;

  const DeliveryMethodsScreen({required this.selectedMethod});

  @override
  _DeliveryMethodsScreenState createState() => _DeliveryMethodsScreenState();
}

class _DeliveryMethodsScreenState extends State<DeliveryMethodsScreen> {
  late String selectedDeliveryMethod;

  final List<String> deliveryMethods = ['Tiêu chuẩn', 'Nhanh'];

  @override
  void initState() {
    super.initState();
    selectedDeliveryMethod = widget.selectedMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phương thức giao hàng',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: deliveryMethods.length,
        itemBuilder: (context, index) {
          final method = deliveryMethods[index];
          final isSelected = selectedDeliveryMethod == method;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDeliveryMethod = method;
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
                  Expanded(
                    child: Text(
                      method,
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
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, selectedDeliveryMethod);
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
