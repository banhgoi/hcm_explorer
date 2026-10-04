class Restaurant {
  final String id;
  final String name;
  final String address;
  final String foodId;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.foodId,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
  return Restaurant(
    id: json['id'].toString(),
    name: json['name'].toString(),
    address: json['address']?.toString() ?? '',
    foodId: json['food_id']?.toString() ?? '',
    latitude: double.parse(json['latitude'].toString()),
    longitude: double.parse(json['longitude'].toString()),
    imageUrl: json['image_url']?.toString() ?? '',
    rating: double.parse(json['rating'].toString()),
  );
}
}
