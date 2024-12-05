import 'package:binh_an_pharmacy/screens/add_address_screen.dart';
import 'package:binh_an_pharmacy/widgets/address_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:binh_an_pharmacy/models/address_model.dart';
import 'package:binh_an_pharmacy/providers/address_provider.dart';

class AddressScreen extends StatefulWidget {
  final int? currentAddressId; // Địa chỉ đang được chọn (nếu có)
  const AddressScreen({Key? key, this.currentAddressId}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int? selectedAddressId;

  @override
  void initState() {
    super.initState();
    selectedAddressId = widget.currentAddressId; // Gán giá trị ban đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn địa chỉ giao hàng'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (addressProvider.addresses.isEmpty) {
            return const Center(child: Text('Không có địa chỉ nào.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: addressProvider.addresses.length,
                  itemBuilder: (context, index) {
                    final address = addressProvider.addresses[index];
                    return AddressItem(
                      address: address,
                      selectedAddressId: selectedAddressId,
                      onAddressSelected: (selectedId) {
                        setState(() {
                          selectedAddressId = selectedId;
                        });
                      }, onAddressDeleted: (int value) {  },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Điều hướng đến màn hình thêm địa chỉ mới
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAddressScreen(),
                      ),
                    );
                  },
                  label: const Text('Thêm địa chỉ mới',
                  style: TextStyle(fontSize: 12, color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (selectedAddressId != null) {
              final selectedAddress = Provider.of<AddressProvider>(context, listen: false)
                  .addresses
                  .firstWhere((address) => address.id == selectedAddressId);
              Navigator.pop(context, selectedAddress); // Trả về đối tượng địa chỉ
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Xác nhận',
            style: TextStyle(fontSize: 12, color: Colors.white),),
        ),
      ),
    );
  }

}
