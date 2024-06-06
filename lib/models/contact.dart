class Contact {
  int id;
  String name;
  String phone;
  String? image;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    this.image,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name':name,
      'phone':phone,
      'image':image,
    };
  }
}
