import 'book.dart';
import 'reader.dart';

class BookRental {
  final int? id;
  final int? bookId;
  final int? readerId;
  final Book? book; // Навигационное свойство
  final Reader? reader; // Навигационное свойство

  BookRental({
    this.id,
    required this.bookId,
    required this.readerId,
    this.book,
    this.reader,
  });

  factory BookRental.fromJson(Map<String, dynamic> json) {
    print('BookRental JSON: $json');
    return BookRental(
      id: json['Id'] as int?,
      bookId: json['BookId'] as int?,
      readerId: json['ReaderId'] as int?,
      book: json['Book'] != null ? Book.fromJson(json['Book'] as Map<String, dynamic>) : null,
      reader: json['Reader'] != null ? Reader.fromJson(json['Reader'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'Id': id,
    'BookId': bookId,
    'ReaderId': readerId,
  };
}
}