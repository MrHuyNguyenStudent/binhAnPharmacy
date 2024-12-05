import 'package:binh_an_pharmacy/models/order.dart';
import 'package:binh_an_pharmacy/services/orders_service.dart';
import 'package:binh_an_pharmacy/widgets/custom_tabbar_widget.dart';
import 'package:binh_an_pharmacy/widgets/order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:binh_an_pharmacy/widgets/bottom_nav_bar_widget.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin {
  int _selectedIndex = 3;
  late TabController _tabController;
  late ApiOrdersService _apiOrdersService;

  List<HoaDon> daGiaoHang = [];
  List<HoaDon> choXacNhan = [];
  List<HoaDon> daXacNhan = [];
  List<HoaDon> dangChuanBi = [];
  List<HoaDon> daHuy = [];
  List<HoaDon> dangVanChuyen = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _apiOrdersService = ApiOrdersService();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final newOrders = await _apiOrdersService.getAllHoaDon();

      setState(() {
        daGiaoHang = newOrders.where((order) =>
        order.trangThaiDonHang == "Đã giao hàng" || order.trangThaiDonHang == "Hoàn thành"
        ).toList();
        choXacNhan = newOrders.where((order) => order.trangThaiDonHang == "Chờ xác nhận").toList();
        daXacNhan = newOrders.where((order) => order.trangThaiDonHang == "Đã xác nhận").toList();
        dangChuanBi = newOrders.where((order) => order.trangThaiDonHang == "Đang chuẩn bị").toList();
        daHuy = newOrders.where((order) => order.trangThaiDonHang == "Đã hủy").toList();
        dangVanChuyen = newOrders.where((order) => order.trangThaiDonHang == "Đang vận chuyển").toList();
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  Widget _buildOrderList(List<HoaDon> hoaDons) {
    return RefreshIndicator(
      onRefresh: _fetchOrders,
      child: hoaDons.isEmpty
          ? _buildEmptyTab("Không có đơn hàng")
          : ListView.builder(
        itemCount: hoaDons.length,
        itemBuilder: (context, index) {
          return OrderItemWidget(hoaDon: hoaDons[index]);
        },
      ),
    );
  }

  Widget _buildEmptyTab(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lịch sử đơn hàng",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: CustomTabBar(
          selectedIndex: _tabController.index,
          onTap: _onTabTapped,
          tabController: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(daGiaoHang),
          _buildOrderList(choXacNhan),
          _buildOrderList(daXacNhan),
          _buildOrderList(dangChuanBi),
          _buildOrderList(daHuy),
          _buildOrderList(dangVanChuyen),
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
