import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatboxService {
  // API key của OpenAI (cần phải thay thế với API key của bạn)
  static const String _apiKey = 'key lỗi';

  // Phương thức công khai để gọi GPT-3 API và lấy câu trả lời
  Future<String> getChatbotResponse(String question) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions'); // URL API GPT-3.5/GPT-4

    // Cấu trúc request body để gửi đến GPT-3.5 hoặc GPT-4 API
    final body = jsonEncode({
      "model": "gpt-3.5-turbo",  // Lựa chọn mô hình GPT-3.5 hoặc GPT-4
      "messages": [
        {
          "role": "user",          // Vai trò của người dùng
          "content": question,     // Câu hỏi từ người dùng
        }
      ],
      "max_tokens": 100,           // Giới hạn số từ trong câu trả lời
      "temperature": 0.7,          // Tùy chỉnh tính sáng tạo của câu trả lời (0-1)
    });

    // Gửi yêu cầu POST đến OpenAI API
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey', // Đảm bảo thêm API key trong header
      },
      body: body,
    );

    // Kiểm tra mã phản hồi HTTP
    if (response.statusCode == 200) {
      try {
        // Giải mã dữ liệu JSON trả về từ OpenAI
        var data = jsonDecode(response.body);

        // Kiểm tra xem trường 'choices' có tồn tại trong phản hồi không
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          // Lấy câu trả lời từ trường 'choices'
          return data['choices'][0]['message']['content'].trim() ?? 'Không có câu trả lời từ GPT-3.5';
        } else {
          return 'Không có câu trả lời từ GPT-3.5';
        }
      } catch (e) {
        // Xử lý khi có lỗi trong quá trình phân tích JSON
        return 'Lỗi phân tích dữ liệu từ API: $e';
      }
    } else {
      // Nếu mã lỗi HTTP không phải 200, trả về thông báo lỗi
      return 'Không thể kết nối đến API. Mã lỗi: ${response.statusCode}';
    }
  }
}
