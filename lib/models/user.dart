class UserModel {
  String? uid;
  String? birthDate;
  String? email;
  String? fullName;
  String? gender;
  String? howDidYouFindOut;
  String? phone;
  String? profession;
  String? token;
  String? userName;

  UserModel({
    this.uid,
    this.birthDate,
    this.email,
    this.fullName,
    this.gender,
    this.howDidYouFindOut,
    this.phone,
    this.profession,
    this.token,
    this.userName,
  });

  // Factory method to create UserModel from a map
  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      birthDate: data['birthDate'],
      email: data['email'],
      fullName: data['fullName'],
      gender: data['gender'],
      howDidYouFindOut: data['howDidYouFindOut'],
      phone: data['phone'],
      profession: data['profession'],
      token: data['token'],
      userName: data['userName'],
    );
  }

  // Method to convert UserModel to a map (if needed)
  Map<String, dynamic> toMap() {
    return {
      'birthDate': birthDate,
      'email': email,
      'fullName': fullName,
      'gender': gender,
      'howDidYouFindOut': howDidYouFindOut,
      'phone': phone,
      'profession': profession,
      'token': token,
      'userName': userName,
    };
  }
}
