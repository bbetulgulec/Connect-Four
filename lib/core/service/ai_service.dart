import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const String _url =
      "https://connect-four-ai.connect-four-ai.workers.dev";

  static Future<int> getAiMove(List<List<int>> board) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"board": board}),
    );
 
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["column"];
    } else {
      throw Exception("AI cevap vermedi");
    }
  }
}
