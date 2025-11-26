import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/reader.dart';
import '../models/book_rental.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:5247/api'; // Замените на ваш URL

  static Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse('$_baseUrl/books'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Book.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Reader>> getReaders() async {
    final response = await http.get(Uri.parse('$_baseUrl/readers'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Reader.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load readers');
    }
  }

  static Future<List<BookRental>> getBookRentals() async {
    final response = await http.get(Uri.parse('$_baseUrl/bookrental'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => BookRental.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load book rentals');
    }
  }

  // Методы для добавления (POST) будут здесь (см. примечание ниже)
}