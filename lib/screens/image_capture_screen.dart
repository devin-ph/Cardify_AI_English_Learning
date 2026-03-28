import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:typed_data';
import '../models/analysis_result.dart';
import '../services/network_service.dart';

class ImageCaptureScreen extends StatefulWidget {
  const ImageCaptureScreen({super.key});

  @override
  State<ImageCaptureScreen> createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  final FlutterTts _flutterTts = FlutterTts();
  static const String _lanApiBase = 'http://192.168.1.28:8000';
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;
  AnalysisResult? _analysisResult;
  String _errorMessage = '';

  String get _apiUrl => '$_lanApiBase/analyze-image';
  final NetworkService _networkService = NetworkService(
    'http://192.168.1.28:8000/analyze-image',
  );

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
  }


  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 640,
      maxHeight: 640,
    );
    if (image != null) {
      await _processImage(image);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 640,
      maxHeight: 640,
    );
    if (image != null) {
      await _processImage(image);
    }
  }

  Future<void> _processImage(XFile imageFile) async {
    if (!mounted) return;
    final imageBytes = await imageFile.readAsBytes();
    setState(() {
      _selectedImageBytes = imageBytes;
      _isLoading = true;
      _errorMessage = '';
      _analysisResult = null;
    });
    try {
      final result = await _networkService.uploadImage(imageBytes);
      if (!mounted) return;
      setState(() {
        _analysisResult = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Lỗi xử lý ảnh: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _speakWord() async {
    if (_analysisResult != null) {
      await _flutterTts.speak(_analysisResult!.word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ảnh xem trước
            if (_selectedImageBytes == null)
              Container(
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No image selected',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _selectedImageBytes!,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Các nút chức năng chụp ảnh
            if (!_isLoading && _analysisResult == null)
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _captureImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Chụp ảnh'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Chọn từ thư viện'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            // Nút từ điển ở giữa màn hình
            if (!_isLoading && _analysisResult == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Điều hướng sang trang từ điển nếu có
                    },
                    icon: const Icon(Icons.menu_book),
                    label: const Text('Từ điển'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            if (_isLoading)
              Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang phân tích ảnh...'),
                ],
              ),
            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Error',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = '';
                          _selectedImageBytes = null;
                          _analysisResult = null;
                        });
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            if (_analysisResult != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Từ tiếng Anh:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _analysisResult!.word,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Phiên âm (IPA):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _analysisResult!.phonetic,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _speakWord,
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Phát âm từ'),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Nghĩa tiếng Việt:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _analysisResult!.vietnameseMeaning,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Loại từ:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _analysisResult!.wordType,
                      style: TextStyle(fontSize: 14, color: Colors.blue[900]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Câu ví dụ:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      border: Border.all(color: Colors.amber, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _analysisResult!.exampleSentence,
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Hướng dẫn phát âm:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      border: Border.all(color: Colors.green, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _analysisResult!.pronunciationGuide,
                      style: const TextStyle(fontSize: 14, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedImageBytes = null;
                        _analysisResult = null;
                        _errorMessage = '';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Chụp ảnh mới',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
