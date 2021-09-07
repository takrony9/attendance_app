class User {
  String userId;
  String token;
  DateTime expiryDate;
  String password;
  String userName;
  String email;
  String phone;
  String image;
  int type;
  String deviceToken;

  User({
    this.image,
    this.phone,
    this.email,
    this.userName,
    this.userId,
    this.type,
    this.deviceToken,
  });
}
