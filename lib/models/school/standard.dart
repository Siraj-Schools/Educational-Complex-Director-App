class Standard {
  final String id;
  final String name;
  final int order;
  final String type;

  Standard({
    required this.id,
    required this.name,
    required this.order,
    required this.type,
  });

  factory Standard.fromJson(Map<String, dynamic> json) {
    return Standard(
      id: json['standardId'],
      name: json['standardName'],
      order: json['order'],
      type: json['type'],
    );
  }
}
