class SocialLoginModel {
  String? name;
   String? email;
   String? phone;
   String? uId;
   String? bio;
   String? image;
   String? cover;
   bool? isEmailVerification;

  SocialLoginModel(this.name, this.email, this.phone, this.uId,
      this.bio,
      this.image,
      this.cover,
      this.isEmailVerification);
  SocialLoginModel.formJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    bio = json['bio'];
    image = json['image'];
    cover = json['cover'];
    isEmailVerification = json['isEmailVerification'];
  }

  Map<String, dynamic> toMap(){
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "uId": uId,
      "bio": bio,
      "image": image,
      "cover": cover,
      "isEmailVerification": isEmailVerification,
    };
  }
}