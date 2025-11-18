class Source {
  final String? id;
  final String name;

  Source({this.id, required this.name});

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(id: map['id'], name: map['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
