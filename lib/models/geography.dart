class Geography {
  final String id;
  final String name;

  Geography({required this.id, required this.name});

  factory Geography.fromJson(Map<String, dynamic> json) =>
      Geography(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
