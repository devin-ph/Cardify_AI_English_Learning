import 'package:flutter/material.dart';

class DictionaryScreen extends StatelessWidget {
  final List<Map<String, String>> words;
  const DictionaryScreen({
    Key? key,
    this.words = const [
      {
        'image': '',
        'word': 'apple',
        'type': 'noun',
        'meaning': 'quả táo',
        'phonetic': '/ˈæp.əl/'
      },
      {
        'image': '',
        'word': 'run',
        'type': 'verb',
        'meaning': 'chạy',
        'phonetic': '/rʌn/'
      },
      {
        'image': '',
        'word': 'beautiful',
        'type': 'adj',
        'meaning': 'đẹp',
        'phonetic': '/ˈbjuː.tɪ.fəl/'
      },
      {
        'image': '',
        'word': 'quickly',
        'type': 'adv',
        'meaning': 'nhanh chóng',
        'phonetic': '/ˈkwɪk.li/'
      },
      {
        'image': '',
        'word': 'book',
        'type': 'noun',
        'meaning': 'quyển sách',
        'phonetic': '/bʊk/'
      },
      {
        'image': '',
        'word': 'cat',
        'type': 'noun',
        'meaning': 'con mèo',
        'phonetic': '/kæt/'
      },
      {
        'image': '',
        'word': 'swim',
        'type': 'verb',
        'meaning': 'bơi',
        'phonetic': '/swɪm/'
      },
      {
        'image': '',
        'word': 'quick',
        'type': 'adj',
        'meaning': 'nhanh',
        'phonetic': '/kwɪk/'
      },
      {
        'image': '',
        'word': 'slowly',
        'type': 'adv',
        'meaning': 'một cách chậm rãi',
        'phonetic': '/ˈsləʊ.li/'
      },
      {
        'image': '',
        'word': 'pen',
        'type': 'noun',
        'meaning': 'cây bút',
        'phonetic': '/pen/'
      },
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Từ điển'),
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue[100]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image, color: Colors.blueGrey), // Placeholder for image
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(word['word'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(word['type'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.blue)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(word['meaning'] ?? '', style: const TextStyle(fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(word['phonetic'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
