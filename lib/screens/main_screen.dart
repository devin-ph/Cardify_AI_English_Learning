import 'package:app_btl/screens/deck_list_screen.dart';
import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../services/saved_cards_repository.dart';
import '../widgets/ai_voice_chat_dialog.dart';
import '../widgets/profile_icon.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'image_capture_screen.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'dictionary_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final SavedCardsRepository _cardsRepository = SavedCardsRepository.instance;

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

  void _onCameraCompleted() {
    setState(() {
      _currentIndex = 2; // Dictionary tab
    });
  }

  void _onProfileTap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  Future<void> _onAiChatTap() async {
    final result = await showDialog<VoiceChatSessionResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AiVoiceChatDialog(),
    );

    if (!mounted || result == null || result.candidates.isEmpty) {
      return;
    }

    final savedWords = await _showChatVocabularySaveDialog(result.candidates);
    if (!mounted || savedWords.isEmpty) {
      return;
    }

    final wordsText = savedWords.take(4).join(', ');
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content: Text('Đã lưu từ mới: $wordsText'),
          leading: const Icon(Icons.menu_book),
          actions: [
            TextButton(
              onPressed: () {
                messenger.hideCurrentMaterialBanner();
                setState(() {
                  _currentIndex = 2;
                });
              },
              child: const Text('Đi đến từ điển'),
            ),
          ],
        ),
      );
  }

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
        return DeckListScreen();
      case 4:
        return const Center(child: Text('Thành tựu'));
      case -1:
        return ImageCaptureScreen(onDone: _onCameraCompleted);
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
        actions: [ProfileIcon(onTap: _onProfileTap)],
      ),
      body: Stack(
        children: [
          Positioned.fill(child: _getBody()),
          if (_currentIndex == 0)
            Positioned(
              right: 16,
              bottom: 96,
              child: _AiChatLauncher(onTap: _onAiChatTap),
            ),
        ],
      ),
      floatingActionButton: _currentIndex == -1
          ? null
          : Padding(
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

class _AiChatLauncher extends StatelessWidget {
  const _AiChatLauncher({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(34),
        child: Ink(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF4F8FFF), Color(0xFF7A6BFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x664F8FFF),
                blurRadius: 16,
                spreadRadius: 2,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.smart_toy, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
