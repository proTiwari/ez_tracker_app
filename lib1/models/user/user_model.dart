class UserModel {
  final String? name;
  final String? email;
  final String? userId;
  final String? accountCreationDate;
  final String? lastLogInDate;

  UserModel({
    this.name,
    this.email,
    this.userId,
    this.accountCreationDate,
    this.lastLogInDate,
  });

  factory UserModel.fromMap(Map<String, dynamic>? data, String userId) {
    return UserModel(
      userId: userId,
      name: data?['name'],
      email: data?['email'],
      accountCreationDate: data?['created_date'],
      lastLogInDate: data?['last_login_date'],
    );
  }

  @override
  String toString() {
    return '**UserId:$userId\n**Name:$name\n**Email:$email\n**CreatedDate:$accountCreationDate\n**LastLogInDate:$lastLogInDate';
  }
}
