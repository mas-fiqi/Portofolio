class ProfileModel {
  final String name;
  final int age;
  final String address;
  final String email;
  final String education;
  final List<String> hobbies;
  final String vision;
  final String mission;
  final String description;

  ProfileModel({
    required this.name,
    required this.age,
    required this.address,
    required this.email,
    required this.education,
    required this.hobbies,
    required this.vision,
    required this.mission,
    required this.description,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String,
      age: json['age'] as int,
      address: json['address'] as String,
      email: json['email'] as String,
      education: json['education'] as String,
      hobbies: List<String>.from(json['hobbies']),
      vision: json['vision'] as String,
      mission: json['mission'] as String,
      description: json['description'] as String,
    );
  }
}
