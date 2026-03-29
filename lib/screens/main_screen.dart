import 'package:app_btl/screens/deck_list_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/profile_icon.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'image_capture_screen.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'dictionary_screen.dart';
import 'profile_screen.dart';
import 'flashcard_category_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onCameraTap() {
    setState(() {
      _currentIndex = -1; // Special index for camera
    });
  }

  void _onProfileTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return const CalendarScreen();
      case 2:
        return const DictionaryScreen();
      case 3:
        return  DeckListScreen();
      case 4:
        return const Center(child: Text('Thành tựu'));
      case -1:
        return const ImageCaptureScreen();
      default:
        return const Center(child: Text('Trang chủ'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI English Learning'),
        centerTitle: true,
        elevation: 0,
        actions: [
          ProfileIcon(onTap: _onProfileTap),
        ],
      ),
        body: _getBody(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 28.0),
          child: FloatingActionButton(
            onPressed: _onCameraTap,
            child: const Icon(Icons.camera_alt),
            tooltip: 'Chụp ảnh',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex < 0 ? 0 : _currentIndex,
        onTap: _onNavTap,
        onCameraTap: _onCameraTap,
      ),
    );
  }
}
