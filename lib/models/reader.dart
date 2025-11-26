class Reader {
  final int id;
  final String name;
  final String lastname;

  Reader({required this.id, required this.name, required this.lastname});

  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
    );
  }
}