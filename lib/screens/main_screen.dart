import 'package:app_btl/screens/deck_list_screen.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import '../models/analysis_result.dart';
import '../services/saved_cards_repository.dart';
import '../widgets/ai_voice_chat_dialog.dart';
import '../widgets/profile_icon.dart';
>>>>>>> 32aba5d9832476bdb4b8b3415725e0343e54a669
import '../widgets/custom_bottom_nav_bar.dart';
import 'achievements_screen.dart';
import 'image_capture_screen.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'dictionary_screen.dart';
import 'profile_screen.dart';
<<<<<<< HEAD
import 'achievements_screen.dart';

enum _ProfileMenuAction { profile, settings, logout }
=======
>>>>>>> 32aba5d9832476bdb4b8b3415725e0343e54a669

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _previousIndex = 0;
  final String _userName = 'Explorer';
  final String _userEmail = 'explorer.cardify@example.com';
<<<<<<< HEAD
=======
  final SavedCardsRepository _cardsRepository = SavedCardsRepository.instance;
>>>>>>> 32aba5d9832476bdb4b8b3415725e0343e54a669

  void _setScreenIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
  }

  void _onNavTap(int index) {
    _setScreenIndex(index);
  }

  void _onCameraTap() {
    _setScreenIndex(-1); // Special index for camera
  }

  void _onDrawerNavTap(int index) {
    Navigator.of(context).pop();
    if (index == -1) {
      _onCameraTap();
      return;
    }
    _onNavTap(index);
  }

  void _onProfileTap() {
<<<<<<< HEAD
    Navigator.of(
      context,
    ).push(
=======
    Navigator.of(context).push(
>>>>>>> 32aba5d9832476bdb4b8b3415725e0343e54a669
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  void _onChatTap() {
    showDialog(
      context: context,
      builder: (context) => const AiVoiceChatDialog(),
    );
  }

<<<<<<< HEAD
  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn muốn đăng xuất khỏi Cardify?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đăng xuất thành công.')),
                );
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  void _showProfileDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AnimatedProfileDrawer(
        userName: _userName,
        userEmail: _userEmail,
        onAction: (action) {
          _onProfileMenuSelected(action);
        },
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (_currentIndex != 0) {
      return null;
    }

    return AppBar(
      toolbarHeight: 72,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: const Text(
        'Cardify',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 24,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: _showProfileDrawer,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Text(
                _userName.characters.first,
                style: const TextStyle(
                  color: Color(0xFF1F3E92),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3349FF), Color(0xFF1A79FF), Color(0xFF23B2FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
=======
  Future<List<String>> _showChatVocabularySaveDialog(
    List<ChatVocabularyCandidate> candidates,
  ) async {
    final pending = List<ChatVocabularyCandidate>.from(candidates);
    final savedWords = <String>[];

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> saveOne(ChatVocabularyCandidate candidate) async {
              final normalized = candidate.normalizedWord;
              final existing = await _cardsRepository.findExistingWord(
                normalized,
              );
              if (existing == null) {
                final analysis = AnalysisResult(
                  topic: candidate.topic,
                  word: candidate.word,
                  phonetic: candidate.phonetic,
                  vietnameseMeaning: candidate.vietnameseMeaning,
                  wordType: candidate.intentType,
                  exampleSentence: candidate.exampleSentence,
                  pronunciationGuide: candidate.pronunciationGuide,
                );
                await _cardsRepository.saveResult(analysis, null);
                savedWords.add(candidate.word);
              }

              if (!mounted) {
                return;
              }

              setModalState(() {
                pending.removeWhere(
                  (item) => item.normalizedWord == candidate.normalizedWord,
                );
              });

              if (pending.isEmpty && Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop();
              }
            }

            Future<void> saveAll() async {
              final toSave = List<ChatVocabularyCandidate>.from(pending);
              for (final item in toSave) {
                await saveOne(item);
              }
              if (Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop();
              }
            }

            return AlertDialog(
              title: const Text('Từ phát hiện trong đoạn chat'),
              content: SizedBox(
                width: 420,
                child: pending.isEmpty
                    ? const Text('Không còn từ nào cần lưu.')
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: pending.length,
                        separatorBuilder: (_, __) => const Divider(height: 16),
                        itemBuilder: (context, index) {
                          final item = pending[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.word,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(item.vietnameseMeaning),
                                    if (item.phonetic.isNotEmpty)
                                      Text(
                                        item.phonetic,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              FilledButton(
                                onPressed: () => saveOne(item),
                                child: const Text('Lưu'),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Thoát'),
                ),
                if (pending.isNotEmpty)
                  FilledButton(
                    onPressed: saveAll,
                    child: const Text('Lưu tất cả'),
                  ),
              ],
            );
          },
        );
      },
    );

    return savedWords;
>>>>>>> 32aba5d9832476bdb4b8b3415725e0343e54a669
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          userName: _userName,
          streak: 12,
          level: 5,
          experience: 820,
          nextLevelExperience: 1200,
          onOpenDecks: () => _onNavTap(3),
          onOpenDictionary: () => _onNavTap(2),
          onOpenCameraQuest: _onCameraTap,
        );
      case 1:
        return const CalendarScreen();
      case 2:
        return const DictionaryScreen();
      case 3:
        return DeckListScreen();
      case 4:
        return const AchievementsScreen();
      case -1:
        return const ImageCaptureScreen();
      default:
        return const Center(child: Text('Trang chủ'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: _buildAppBar(),
      body: _getBody(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 28.0),
        child: FloatingActionButton(
          onPressed: _onCameraTap,
          tooltip: 'Chụp ảnh',
          child: const Icon(Icons.camera_alt),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
=======
      appBar: AppBar(
        title: const Text('AI English Learning'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble),
            onPressed: _onChatTap,
            tooltip: 'Chat với AI',
          ),
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
>>>>>>> 32aba5d9832476bdb4b8b3415725e0343e54a669
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex < 0 ? 0 : _currentIndex,
        onTap: _onNavTap,
        onCameraTap: _onCameraTap,
      ),
    );
  }
}
<<<<<<< HEAD

class _DrawerNavTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _DrawerNavTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF66D8FF), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Colors.white54),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedProfileDrawer extends StatefulWidget {
  final String userName;
  final String userEmail;
  final void Function(_ProfileMenuAction) onAction;

  const _AnimatedProfileDrawer({
    required this.userName,
    required this.userEmail,
    required this.onAction,
  });

  @override
  State<_AnimatedProfileDrawer> createState() => _AnimatedProfileDrawerState();
}

class _AnimatedProfileDrawerState extends State<_AnimatedProfileDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _slideAnimation = Tween<double>(begin: 300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.redAccent : const Color(0xFF1E3A8A),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.redAccent : const Color(0xFF1E3A8A),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black26),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
                    child: Text(
                      widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_rounded,
                          title: 'Hồ sơ',
                          onTap: () {
                            Navigator.pop(context);
                            widget.onAction(_ProfileMenuAction.profile);
                          },
                        ),
                        Divider(height: 1, indent: 64, color: Colors.grey[200]),
                        _buildMenuItem(
                          icon: Icons.settings_rounded,
                          title: 'Cài đặt',
                          onTap: () {
                            Navigator.pop(context);
                            widget.onAction(_ProfileMenuAction.settings);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                     decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red[100]!),
                    ),
                    child: _buildMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'Đăng xuất',
                      isDestructive: true,
                      onTap: () {
                        Navigator.pop(context);
                        widget.onAction(_ProfileMenuAction.logout);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
=======
>>>>>>> 32aba5d9832476bdb4b8b3415725e0343e54a669
