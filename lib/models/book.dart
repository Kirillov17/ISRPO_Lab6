class Book {
  final int? id;
  final String? name;

  Book({this.id, required this.name});

  factory Book.fromJson(Map<String, dynamic> json) {
    print('Book JSON: $json');
    return Book(
      id: json['Id'] as int?,
      name: json['Name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'Id': id,
    'Name': name,
  };
}
}