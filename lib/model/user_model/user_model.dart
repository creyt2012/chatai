class UserModel {
  UserModel({
    this.isPremium = false,
    this.textCount = 0,
    this.imageCount = 0,
    required this.isActive,
    required this.email,
    required this.imageUrl,
    required this.uniqueId,
    required this.name,
    required this.phoneNumber,
  });

  bool isActive;
  bool isPremium;
  String email;
  String imageUrl;
  String uniqueId;
  String name;
  String phoneNumber;
  int textCount;
  int imageCount;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        isPremium: json["isPremium"],
        isActive: json["isActive"],
        email: json["email"],
        imageUrl: json["image_url"],
        uniqueId: json["unique_id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        textCount: json["textCount"],
        imageCount: json["imageCount"],
      );

  Map<String, dynamic> toJson() => {
        "isPremium": isPremium,
        "isActive": isActive,
        "email": email,
        "image_url": imageUrl,
        "unique_id": uniqueId,
        "name": name,
        "phoneNumber": phoneNumber,
        "textCount": textCount,
        "imageCount": imageCount,
      };
}
