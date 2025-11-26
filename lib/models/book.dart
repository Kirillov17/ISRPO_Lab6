class Book {
  final int id;
  final String name;

  Book({required this.id, required this.name});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
    );
  }
}