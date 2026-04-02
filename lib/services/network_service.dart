<<<<<<< HEAD
import 'package:http/http.dart' as http;
=======
>>>>>>> 32aba5d9832476bdb4b8b3415725e0343e54a669
import 'dart:convert';
import '../models/analysis_result.dart';

class NetworkService {
  final String apiUrl;
  NetworkService(this.apiUrl);

  Future<AnalysisResult> uploadImage(List<int> imageBytes) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'),
      );
    var streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return AnalysisResult.fromJson(jsonData['data']);
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
