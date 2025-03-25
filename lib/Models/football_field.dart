class FootballField {
  final String name;
  final String location;
  final double rating;
  final String price;
  final String image;
  final String distance;
  final String fieldType; // Thêm trường fieldType

  FootballField({
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.image,
    required this.distance,
    this.fieldType = '', // Mặc định là rỗng
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'rating': rating,
      'price': price,
      'image': image,
      'distance': distance,
      'fieldType': fieldType,
    };
  }

  factory FootballField.fromMap(Map<String, dynamic> map) {
    return FootballField(
      name: map['name'],
      location: map['location'],
      rating: map['rating'],
      price: map['price'],
      image: map['image'],
      distance: map['distance'],
      fieldType: map['fieldType'] ?? '',
    );
  }
}
