class Reader {
  final int? id;
  final String? name;
  final String? lastname;

  Reader({this.id, required this.name, required this.lastname});

  factory Reader.fromJson(Map<String, dynamic> json) {
    print('Reader JSON: $json');
    return Reader(
      id: json['Id'] as int?,
      name: json['Name'] as String?,
      lastname: json['Lastname'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'Id': id,
    'Name': name,
    'Lastname': lastname,
  };
}
}