import 'package:flutter/material.dart';

class FlashcardCategoryDetailScreen extends StatefulWidget {
  final String categoryName;
  const FlashcardCategoryDetailScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<FlashcardCategoryDetailScreen> createState() => _FlashcardCategoryDetailScreenState();
}

class _FlashcardCategoryDetailScreenState extends State<FlashcardCategoryDetailScreen> {
  // Demo flashcards
  final List<Map<String, String>> flashcards = [
    {
      'image': '',
      'word': 'apple',
      'phonetic': '/ˈæp.əl/',
      'meaning': 'quả táo',
      'example': 'I eat an apple every day.'
    },
    {
      'image': '',
      'word': 'run',
      'phonetic': '/rʌn/',
      'meaning': 'chạy',
      'example': 'He can run very fast.'
    },
  ];
  int currentIndex = 0;
  bool showBack = false;

  void _flipCard() {
    setState(() {
      showBack = !showBack;
    });
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      showBack = false;
    });
  }

  void _prevCard() {
    setState(() {
      currentIndex = (currentIndex - 1 + flashcards.length) % flashcards.length;
      showBack = false;
    });
  }

  void _playAudio() {
    // TODO: Phát âm thanh từ tiếng Anh
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phát âm thanh!')));
  }

  @override
  Widget build(BuildContext context) {
    final card = flashcards[currentIndex];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.categoryName),
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            SizedBox(
              width: 370,
              height: 370,
              child: GestureDetector(
                onTap: _flipCard,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => RotationYTransition(turns: anim, child: child),
                  child: showBack
                      ? _buildBack(card)
                      : _buildFront(card),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _prevCard,
                ),
                const SizedBox(width: 32),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _nextCard,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFront(Map<String, String> card) {
    return Stack(
      key: const ValueKey('front'),
      children: [
        Container(
          width: 370,
          height: 370,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.image, size: 70, color: Colors.blueGrey),
              ),
              const SizedBox(height: 22),
              Text(card['word'] ?? '', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(card['phonetic'] ?? '', style: const TextStyle(fontSize: 20, color: Colors.grey)),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            mini: true,
            onPressed: _playAudio,
            child: const Icon(Icons.volume_up),
            backgroundColor: Colors.blue[400],
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildBack(Map<String, String> card) {
    return Container(
      key: const ValueKey('back'),
      width: 370,
      height: 370,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(card['meaning'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            Text(card['example'] ?? '', style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

// Helper for flip animation
class RotationYTransition extends AnimatedWidget {
  final Widget child;
  RotationYTransition({required Animation<double> turns, required this.child}) : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final Animation<double> turns = listenable as Animation<double>;
    final double angle = turns.value * 3.1416;
    return Transform(
      transform: Matrix4.rotationY(angle),
      alignment: Alignment.center,
      child: child,
    );
  }
}
