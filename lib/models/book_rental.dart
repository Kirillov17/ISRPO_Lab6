import 'book.dart';
import 'reader.dart';

class BookRental {
  final int id;
  final int bookId;
  final int readerId;
  final Book? book; // Навигационное свойство
  final Reader? reader; // Навигационное свойство

  BookRental({
    required this.id,
    required this.bookId,
    required this.readerId,
    this.book,
    this.reader,
  });

  factory BookRental.fromJson(Map<String, dynamic> json) {
    return BookRental(
      id: json['id'],
      bookId: json['bookId'],
      readerId: json['readerId'],
      book: json['book'] != null ? Book.fromJson(json['book']) : null,
      reader: json['reader'] != null ? Reader.fromJson(json['reader']) : null,
    );
  }
}