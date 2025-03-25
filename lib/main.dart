import 'package:flutter/material.dart';
import 'Pages/home.dart';
import 'Pages/auth/login_page.dart';
import 'Services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = _authService.isLoggedIn;

    // Đăng ký callback để cập nhật UI khi trạng thái đăng nhập thay đổi
    _authService.setOnAuthStateChanged(() {
      setState(() {
        _isLoggedIn = _authService.isLoggedIn;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đặt Sân Bóng',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: _isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
//C:\Users\84346\Samsung Galaxy S8
