class SocialUserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? bio;
  String? image;
  String? cover;
  bool? isEmailVerified;

  SocialUserModel(
      {this.name,
      this.email,
      this.phone,
      this.uId,
      this.bio,
      this.image,
      this.cover,
      this.isEmailVerified});

  SocialUserModel.formJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    bio = json['bio'];
    image = json['image'];
    cover = json['cover'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "uId": uId,
      "bio": bio,
      "image": image,
      "cover": cover,
      "isEmailVerified": isEmailVerified,
    };
  }
}
