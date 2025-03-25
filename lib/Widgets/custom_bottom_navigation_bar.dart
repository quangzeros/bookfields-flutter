import 'package:flutter/material.dart';
import '../Pages/search_page.dart';
import '../Pages/booking_page.dart';
import '../Pages/profile_page.dart'; // Thêm import

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final BuildContext parentContext;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.parentContext,
  });

  void _handleNavigation(int index) {
    if (index == currentIndex) return;

    if (index == 1) {
      // Nếu nhấn vào tab tìm kiếm và không ở trang tìm kiếm
      if (currentIndex != 1) {
        Navigator.push(
          parentContext,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
      }
      return;
    }

    if (index == 2) {
      // Nếu nhấn vào tab đặt lịch và không ở trang đặt lịch
      if (currentIndex != 2) {
        Navigator.push(
          parentContext,
          MaterialPageRoute(builder: (context) => const BookingPage()),
        );
      }
      return;
    }

    if (index == 3) {
      // Nếu nhấn vào tab tài khoản và không ở trang tài khoản
      if (currentIndex != 3) {
        Navigator.push(
          parentContext,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
      return;
    }

    // Xử lý các tab khác
    onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          onTap: _handleNavigation,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Tìm kiếm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Đặt lịch',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Tài khoản',
            ),
          ],
        ),
      ],
    );
  }
}

// Widget kết hợp cả FloatingActionButton và BottomNavigationBar
class CustomBottomNavWithFAB extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final BuildContext parentContext;
  final VoidCallback? onFabPressed;

  const CustomBottomNavWithFAB({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.parentContext,
    this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          parentContext: parentContext,
        ),
      ],
    );
  }
}
