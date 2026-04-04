class TopicClassifier {
  static const List<String> topics = [
    'Đồ điện tử', // 0
    'Đồ nội thất', // 1
    'Động vật', // 2
    'Thiên nhiên', // 3
    'Công nghệ', // 4
    'Học tập', // 5
    'Đồ ăn', // 6
    'Phương tiện', // 7
  ];

  static const Map<String, List<String>> keywords = {
    'Đồ điện tử': [
      'phone',
      'tablet',
      'camera',
      'speaker',
      'headphone',
      'charger',
      'battery',
      'remote',
      'điện thoại',
      'máy tính bảng',
      'máy ảnh',
      'loa',
      'tai nghe',
      'bộ sạc',
      'pin',
      'điều khiển',
      'electronic',
      'device',
      'gadget',
    ],
    'Đồ nội thất': [
      'chair',
      'table',
      'bed',
      'lamp',
      'door',
      'window',
      'sofa',
      'cabinet',
      'ghế',
      'bàn',
      'giường',
      'đèn',
      'cửa',
      'tủ',
      'sofa',
      'nồi',
      'chảo',
      'kitchen',
      'utensil',
      'plate',
      'cup',
      'spoon',
      'fork',
      'dĩa',
      'cốc',
      'muỗng',
    ],
    'Thiên nhiên': [
      'tree',
      'flower',
      'mountain',
      'river',
      'sky',
      'sun',
      'moon',
      'cloud',
      'rain',
      'cây',
      'hoa',
      'núi',
      'sông',
      'trời',
      'mặt trời',
      'mặt trăng',
      'mây',
      'mưa',
      'forest',
      'ocean',
      'sea',
      'beach',
      'grass',
      'stone',
      'rock',
      'water',
      'rừng',
      'biển',
      'bãi biển',
      'cỏ',
      'đá',
    ],
    'Công nghệ': [
      'computer',
      'phone',
      'laptop',
      'tablet',
      'robot',
      'camera',
      'screen',
      'keyboard',
      'máy tính',
      'điện thoại',
      'robot',
      'camera',
      'màn hình',
      'bàn phím',
      'chuột',
      'electric',
      'digital',
      'software',
      'app',
      'internet',
      'wifi',
      'server',
      'điện tử',
      'kỹ thuật số',
      'phần mềm',
    ],
    'Đồ ăn': [
      'apple',
      'banana',
      'bread',
      'rice',
      'meat',
      'fish',
      'chicken',
      'egg',
      'milk',
      'táo',
      'chuối',
      'bánh',
      'cơm',
      'thịt',
      'cá',
      'gà',
      'trứng',
      'sữa',
      'orange',
      'lemon',
      'cheese',
      'sugar',
      'salt',
      'oil',
      'butter',
      'cam',
      'chanh',
      'phô mai',
      'đường',
      'muối',
      'dầu',
      'bơ',
      'đơ',
    ],
    'Động vật': [
      'cat',
      'dog',
      'bird',
      'fish',
      'lion',
      'tiger',
      'elephant',
      'monkey',
      'rabbit',
      'mèo',
      'chó',
      'chim',
      'cá',
      'sư tử',
      'hổ',
      'voi',
      'khỉ',
      'thỏ',
      'horse',
      'cow',
      'pig',
      'sheep',
      'snake',
      'insect',
      'butterfly',
      'spider',
      'ngựa',
      'bò',
      'lợn',
      'cừu',
      'rắn',
      'côn trùng',
      'bươm bướm',
      'nhện',
    ],
    'Phương tiện': [
      'car',
      'bus',
      'train',
      'plane',
      'bike',
      'motorcycle',
      'truck',
      'taxi',
      'boat',
      'ô tô',
      'xe buýt',
      'tàu',
      'máy bay',
      'xe đạp',
      'xe máy',
      'xe tải',
      'taxi',
      'thuyền',
      'helicopter',
      'ship',
      'submarine',
      'bicycle',
      'vehicle',
      'transport',
      'trực thăng',
      'tàu',
      'tàu ngầm',
      'xe cộ',
      'vận tải',
    ],
    'Học tập': [
      'study',
      'learn',
      'read',
      'write',
      'book',
      'notebook',
      'pen',
      'pencil',
      'class',
      'classroom',
      'teacher',
      'student',
      'school',
      'lesson',
      'homework',
      'exam',
      'quiz',
      'học',
      'đọc',
      'viết',
      'sách',
      'vở',
      'bút',
      'lớp học',
      'giáo viên',
      'học sinh',
      'trường',
      'bài học',
      'bài tập',
      'kiểm tra',
      'kỳ thi',
    ],
  };

  /// Classify word vào topic tương ứng dựa trên keyword matching
  static String classifyWord(String word, String meaning) {
    final lowerWord = word.toLowerCase();
    final lowerMeaning = meaning.toLowerCase();
    final combined = '$lowerWord $lowerMeaning';

    // Score cho mỗi topic
    final scores = <String, int>{};
    for (final topic in topics) {
      scores[topic] = 0;
    }

    // Check keyword matching
    for (final topic in topics) {
      final topicKeywords = keywords[topic] ?? [];
      for (final keyword in topicKeywords) {
        if (combined.contains(keyword.toLowerCase())) {
          scores[topic] = (scores[topic] ?? 0) + 1;
        }
      }
    }

    // Find topic với score cao nhất
    String bestTopic = topics[0];
    int maxScore = 0;

    for (final entry in scores.entries) {
      if (entry.value > maxScore) {
        maxScore = entry.value;
        bestTopic = entry.key;
      }
    }

    // Nếu không match keyword, return default
    return maxScore > 0 ? bestTopic : topics[0];
  }

  /// Get topic index
  static int getTopicIndex(String topicName) {
    return topics.indexOf(topicName);
  }

  /// Get topic name from index
  static String getTopicName(int index) {
    return topics.isNotEmpty && index >= 0 && index < topics.length
        ? topics[index]
        : topics[0];
  }
}
