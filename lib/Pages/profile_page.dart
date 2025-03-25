import 'package:flutter/material.dart';
import '../Widgets/custom_bottom_navigation_bar.dart';
import '../Services/auth_service.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3; // Tab tài khoản có index là 3
  final _authService = AuthService();

  // Lấy thông tin người dùng từ AuthService
  late String _userName;
  late String _userEmail;
  late String _userPhone;
  final String _userAvatar =
      "https://media.vov.vn/sites/default/files/styles/large/public/2025-03/ronaldo-2_0.jpg";

  @override
  void initState() {
    super.initState();
    _userName =
        _authService.userName.isEmpty ? "Người dùng" : _authService.userName;
    _userEmail = _authService.userEmail;
    _userPhone = "0987654321"; // Default placeholder
  }

  // Tùy chọn menu
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Thông tin cá nhân',
      'icon': Icons.person_outline,
      'color': Colors.blue,
    },
    {
      'title': 'Lịch sử đặt sân',
      'icon': Icons.history,
      'color': Colors.purple,
    },
    {
      'title': 'Phương thức thanh toán',
      'icon': Icons.payment,
      'color': Colors.orange,
    },
    {
      'title': 'Sân bóng yêu thích',
      'icon': Icons.favorite_border,
      'color': Colors.red,
    },
    {
      'title': 'Thông báo',
      'icon': Icons.notifications_outlined,
      'color': Colors.green,
      'badge': 2,
    },
    {
      'title': 'Cài đặt',
      'icon': Icons.settings_outlined,
      'color': Colors.grey.shade700,
    },
    {
      'title': 'Trợ giúp & Hỗ trợ',
      'icon': Icons.help_outline,
      'color': Colors.teal,
    },
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Navigate back to appropriate page
    if (index != 3) {
      Navigator.pop(context);
    }
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final phoneController = TextEditingController(text: _userPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chỉnh sửa thông tin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 20),

                // Avatar edit
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_userAvatar),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Handle image change
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tính năng đang phát triển'),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Name field
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Họ tên',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),

                // Email field
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 15),

                // Phone field
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 30),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Save changes
                      setState(() {
                        _userName = nameController.text;
                        _userEmail = emailController.text;
                        _userPhone = phoneController.text;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thông tin đã được cập nhật'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text(
                      'Lưu thay đổi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              // Đóng dialog trước
              Navigator.pop(context);

              // Thực hiện đăng xuất ngay lập tức (không cần async)
              _authService.logout();

              // Chuyển hướng về trang đăng nhập
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // Xóa toàn bộ stack điều hướng
              );
            },
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(int index) {
    final item = _menuItems[index];

    switch (index) {
      case 0: // Thông tin cá nhân
        _showEditProfileDialog();
        break;
      case 1: // Lịch sử đặt sân
      case 2: // Phương thức thanh toán
      case 3: // Sân bóng yêu thích
      case 4: // Thông báo
      case 5: // Cài đặt
      case 6: // Trợ giúp & Hỗ trợ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tính năng ${item['title']} đang phát triển')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.green,
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_userAvatar),
                  ),
                  const SizedBox(height: 15),

                  // Name
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Email
                  Text(
                    _userEmail.isEmpty ? "Khách" : _userEmail,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Edit Profile Button
                  ElevatedButton.icon(
                    onPressed: _showEditProfileDialog,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Chỉnh sửa thông tin'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _menuItems.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 70,
                ),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return ListTile(
                    leading: Icon(
                      item['icon'] ?? Icons.circle,
                      color: item['color'] ?? Colors.grey,
                    ),
                    title: Text(item['title'] ?? ''),
                    trailing: item.containsKey('badge')
                        ? Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              item['badge'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: () => _handleMenuAction(index),
                  );
                },
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.red, width: 1),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex, // Sửa từ index thành currentIndex
        onTap: _onItemTapped, // Giữ nguyên onTap
        parentContext: context, // Thêm tham số parentContext
      ),
    );
  }
}
