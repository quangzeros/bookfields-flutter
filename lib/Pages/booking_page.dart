import 'package:flutter/material.dart';
import '../Models/football_field.dart';
import '../Models/dummy_data.dart';
import '../Widgets/custom_bottom_navigation_bar.dart';
import 'package:intl/intl.dart';

// Định nghĩa model Booking để quản lý thông tin đặt sân
class Booking {
  final String id;
  final FootballField field;
  final DateTime date;
  final String timeSlot;
  final String duration;
  final double price;
  final String status; // pending, confirmed, completed, cancelled

  Booking({
    required this.id,
    required this.field,
    required this.date,
    required this.timeSlot,
    required this.duration,
    required this.price,
    required this.status,
  });
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with SingleTickerProviderStateMixin {
  final int _selectedIndex = 2; // Tab index cho trang đặt lịch
  late TabController _tabController;

  // Dữ liệu đặt sân mẫu
  final List<Booking> _bookings = [];

  // Danh sách trạng thái tab
  final List<String> _tabs = ['Sắp tới', 'Hoàn thành', 'Đã hủy'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    // Khởi tạo dữ liệu mẫu
    _generateSampleBookings();
  }

  // Tạo dữ liệu đặt sân mẫu
  void _generateSampleBookings() {
    final fields = DummyData.featuredFields;

    // Đặt sân sắp tới
    _bookings.add(
      Booking(
        id: 'B001',
        field: fields[0],
        date: DateTime.now().add(const Duration(days: 2)),
        timeSlot: '18:00 - 20:00',
        duration: '2 giờ',
        price: 600000,
        status: 'confirmed',
      ),
    );

    _bookings.add(
      Booking(
        id: 'B002',
        field: fields[1],
        date: DateTime.now().add(const Duration(days: 5)),
        timeSlot: '19:00 - 21:00',
        duration: '2 giờ',
        price: 700000,
        status: 'pending',
      ),
    );

    // Đặt sân đã hoàn thành
    _bookings.add(
      Booking(
        id: 'B003',
        field: fields[2],
        date: DateTime.now().subtract(const Duration(days: 3)),
        timeSlot: '17:00 - 19:00',
        duration: '2 giờ',
        price: 800000,
        status: 'completed',
      ),
    );

    _bookings.add(
      Booking(
        id: 'B004',
        field: fields[0],
        date: DateTime.now().subtract(const Duration(days: 10)),
        timeSlot: '15:00 - 17:00',
        duration: '2 giờ',
        price: 600000,
        status: 'completed',
      ),
    );

    // Đặt sân đã hủy
    _bookings.add(
      Booking(
        id: 'B005',
        field: fields[1],
        date: DateTime.now().subtract(const Duration(days: 2)),
        timeSlot: '20:00 - 22:00',
        duration: '2 giờ',
        price: 700000,
        status: 'cancelled',
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Phương thức điều hướng khi chọn tab
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      // Quay về trang chủ
      Navigator.pop(context);
    } else if (index == 1) {
      // Chuyển đến trang tìm kiếm
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang chuyển hướng đến trang Tìm kiếm')),
      );
    } else if (index == 3) {
      // Chuyển đến trang tài khoản
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang phát triển tính năng Tài khoản')),
      );
    }
  }

  // Hủy đặt sân
  void _cancelBooking(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đặt sân'),
        content: Text(
            'Bạn có chắc chắn muốn hủy đặt sân "${booking.field.name}" vào lúc ${booking.timeSlot} ngày ${DateFormat('dd/MM/yyyy').format(booking.date)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final index = _bookings.indexOf(booking);
                _bookings[index] = Booking(
                  id: booking.id,
                  field: booking.field,
                  date: booking.date,
                  timeSlot: booking.timeSlot,
                  duration: booking.duration,
                  price: booking.price,
                  status: 'cancelled',
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã hủy đặt sân thành công')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hủy đặt sân'),
          ),
        ],
      ),
    );
  }

  // Tạo lại đặt sân đã hủy
  void _rebookCancelled(Booking booking) {
    setState(() {
      final index = _bookings.indexOf(booking);
      _bookings[index] = Booking(
        id: booking.id,
        field: booking.field,
        date: DateTime.now().add(const Duration(days: 7)),
        timeSlot: booking.timeSlot,
        duration: booking.duration,
        price: booking.price,
        status: 'pending',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đặt lại sân thành công')),
    );
  }

  // Xem chi tiết đặt sân
  void _viewBookingDetails(Booking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chi tiết đặt sân',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),

              // Thông tin sân bóng
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      booking.field.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.field.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                booking.field.location,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${booking.field.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Thông tin đặt sân
              const SizedBox(height: 24),
              const Text(
                'Thông tin đặt sân',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                  Icons.confirmation_number_outlined, 'Mã đặt sân', booking.id),
              _buildDetailRow(Icons.calendar_today_outlined, 'Ngày đặt',
                  DateFormat('dd/MM/yyyy').format(booking.date)),
              _buildDetailRow(Icons.access_time, 'Khung giờ', booking.timeSlot),
              _buildDetailRow(
                  Icons.timelapse_outlined, 'Thời lượng', booking.duration),
              _buildDetailRow(Icons.attach_money, 'Giá tiền',
                  '${NumberFormat('#,###').format(booking.price.toInt())}đ'),
              _buildDetailRow(
                Icons.circle,
                'Trạng thái',
                _getStatusText(booking.status),
                statusColor: _getStatusColor(booking.status),
              ),

              // Nút hành động
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: booking.status == 'confirmed' ||
                        booking.status == 'pending'
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _cancelBooking(booking);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Hủy đặt sân',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : booking.status == 'cancelled'
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _rebookCancelled(booking);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Đặt lại sân',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Đặt lại',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget hàng thông tin chi tiết
  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: statusColor ?? Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  // Lấy văn bản trạng thái
  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'completed':
        return 'Đã hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  // Lấy màu trạng thái
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Đặt lịch',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.green,
          indicatorWeight: 3,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab sắp tới
          _buildBookingList(_bookings
              .where((b) => b.status == 'confirmed' || b.status == 'pending')
              .toList()),

          // Tab hoàn thành
          _buildBookingList(
              _bookings.where((b) => b.status == 'completed').toList()),

          // Tab đã hủy
          _buildBookingList(
              _bookings.where((b) => b.status == 'cancelled').toList()),
        ],
      ),
      // Thêm custom bottom navigation bar
      bottomNavigationBar: CustomBottomNavWithFAB(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        parentContext: context,
        onFabPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Chức năng đặt sân nhanh đang phát triển')),
          );
        },
      ),
    );
  }

  // Widget danh sách đặt sân
  Widget _buildBookingList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Không có lịch đặt sân nào',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đặt sân bóng ngay để trải nghiệm',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Chuyển đến trang tìm kiếm
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Đang chuyển hướng đến trang Tìm kiếm')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Tìm sân ngay'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return GestureDetector(
          onTap: () => _viewBookingDetails(booking),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header với trạng thái
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mã đặt sân: ${booking.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(booking.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Thông tin sân bóng
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          booking.field.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.field.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    booking.field.location,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(booking.date),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 12,
                                  width: 1,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  booking.timeSlot,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Divider(
                  height: 1,
                  color: Colors.grey[200],
                ),

                // Footer với giá và nút hành động
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tổng tiền',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${NumberFormat('#,###').format(booking.price.toInt())}đ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      if (booking.status == 'confirmed' ||
                          booking.status == 'pending')
                        ElevatedButton(
                          onPressed: () => _cancelBooking(booking),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Hủy đặt sân'),
                        )
                      else if (booking.status == 'cancelled')
                        ElevatedButton(
                          onPressed: () => _rebookCancelled(booking),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Đặt lại sân'),
                        )
                      else
                        ElevatedButton(
                          onPressed: () {
                            // Đặt lại sân đã hoàn thành
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Đặt lại'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
