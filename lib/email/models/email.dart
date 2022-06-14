import 'dart:convert';

import 'package:http/http.dart' as http;

class Email {
  final String name;
  final String address;
  final String subject;
  final String message;

  Email({
    required this.name,
    required this.address,
    required this.subject,
    required this.message,
  });
}

Future sendEmail({required Email email}) async {
  const serviceId = "service_wvnq5xx";
  const templateId = "template_9iet07u";
  const userId = "Rj8KvboVVy7jK0D7x";

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(url, headers: {
    'Content-Type': 'application/json',
  }, body: jsonEncode({
    'service_id': serviceId,
    'template_id': templateId,
    'user_id': userId,
    'template_params': {
      'user_name': email.name,
      'user_email': email.address,
      'user_subject': email.subject,
      'user_message': email.message,
    }
  }));

  print(response.body);
}
