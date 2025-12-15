import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import 'login_admin.dart';
import 'admin_home_screen.dart' as admin_home_screen;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statistik Indonesia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1976D2),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),

      // Halaman awal
      home: const AppInitializer(),

      // Definisi semua route
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/admin-home': (context) => const admin_home_screen.AdminHomeScreen(),
        '/admin': (context) => const admin_home_screen.AdminHomeScreen(),
      },
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({Key? key}) : super(key: key);

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print("🚀 Inisialisasi aplikasi...");

      // Splash minimal 3 detik
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      print("✅ Aplikasi siap");

      // Navigasi setelah frame pertama agar tidak crash
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        // SELALU ke Login Screen setelah splash
        // User harus pilih setiap kali buka app
        print("➡️ Navigasi ke LoginScreen");
        Navigator.pushReplacementNamed(context, '/login');
      });
    } catch (e, s) {
      print("❌ Error saat inisialisasi: $e");
      print(s); 
      // Fallback ke login jika terjadi error
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }//nice
  }

  @override
  Widget build(BuildContext context) {
    // Splash screen tetap tampil selama inisialisasi
    return const SplashScreen();
  }
}