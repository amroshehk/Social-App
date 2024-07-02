class SocialLoginModel {
  String? name;
   String? email;
   String? phone;
   String? uId;
   bool? isEmailVerification;

  SocialLoginModel(this.name, this.email, this.phone, this.uId, this.isEmailVerification);
  SocialLoginModel.formJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    isEmailVerification = json['isEmailVerification'];
  }

  Map<String, dynamic> toMap(){
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "uId": uId,
      "isEmailVerification": isEmailVerification,
    };
  }
}