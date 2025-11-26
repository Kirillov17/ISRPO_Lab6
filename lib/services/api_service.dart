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

  static Future<Book> addBook(Book book) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/books'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(book.toJson()),
  );
  if (response.statusCode == 201) {
    return Book.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to add book');
  }
}

static Future<Reader> addReader(Reader reader) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/readers'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'Name': reader.name,
      'Lastname': reader.lastname,
    }),
  );
  
  print('Add Reader Response: ${response.statusCode}');
  print('Add Reader Body: ${response.body}');
  
  if (response.statusCode == 201) {
    return Reader.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to add reader: ${response.body}');
  }
}

static Future<BookRental> addBookRental(BookRental rental) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/bookrental'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'BookId': rental.bookId,
      'ReaderId': rental.readerId,
    }),
  );
  
  print('Add Rental Response: ${response.statusCode}');
  print('Add Rental Body: ${response.body}');
  
  if (response.statusCode == 201) {
    return BookRental.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to add book rental: ${response.body}');
  }
  
}
static Future<void> deleteBook(int id) async {
  final response = await http.delete(
    Uri.parse('$_baseUrl/books/$id'),
  );
  
  if (response.statusCode != 204) {
    throw Exception('Failed to delete book');
  }
}

static Future<void> deleteReader(int id) async {
  final response = await http.delete(
    Uri.parse('$_baseUrl/readers/$id'),
  );
  
  if (response.statusCode != 204) {
    throw Exception('Failed to delete reader');
  }
}

static Future<void> deleteBookRental(int id) async {
  final response = await http.delete(
    Uri.parse('$_baseUrl/bookrental/$id'),
  );
  
  if (response.statusCode != 204) {
    throw Exception('Failed to delete book rental');
  }
}
}