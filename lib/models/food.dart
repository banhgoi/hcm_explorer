class Food {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }
}