import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/saved_card.dart';
import '../services/saved_cards_repository.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final SavedCardsRepository _repository = SavedCardsRepository.instance;
  late final Stream<List<SavedCard>> _cardsStream = _repository.watchCards();

  Future<void> _openCardDetails(SavedCard card) async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Chi tiet tu',
      barrierColor: Colors.black45,
      pageBuilder: (context, _, __) {
        return SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CardDetailImage(imageUrl: card.imageUrl),
                      const SizedBox(height: 16),
                      Text(
                        card.word,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        card.phonetic,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        card.meaning,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Dong'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curved = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutBack,
        );
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 6 * anim1.value,
                sigmaY: 6 * anim1.value,
              ),
              child: Container(color: Colors.black.withValues(alpha: 0)),
            ),
            Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.75, end: 1.0).animate(curved),
                child: FadeTransition(opacity: anim1, child: child),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu dien'),
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<List<SavedCard>>(
          stream: _cardsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _CenteredMessage(
                message: 'Khong the tai du lieu: ${snapshot.error}',
                icon: Icons.error_outline,
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final cards = snapshot.data!;
            if (cards.isEmpty) {
              return const _CenteredMessage(
                message: 'Chua co tu nao duoc luu',
                icon: Icons.menu_book_outlined,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final card = cards[index];
                return ListTile(
                  onTap: () => _openCardDetails(card),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  tileColor: Colors.blue[50],
                  leading: _CardThumbnail(imageUrl: card.imageUrl),
                  title: Text(
                    card.word,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(card.meaning),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CardThumbnail extends StatelessWidget {
  const _CardThumbnail({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? const Icon(Icons.image, color: Colors.blueGrey)
          : null,
    );
  }
}

class _CardDetailImage extends StatelessWidget {
  const _CardDetailImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        width: 230,
        height: 230,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.image, size: 120, color: Colors.blueGrey),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl!,
        height: 230,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 230,
          height: 230,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.broken_image, color: Colors.blueGrey),
        ),
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.message, required this.icon});

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.blueGrey),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
