class LoginReqModel {
  String? email;
  String? password;
  String? name;

  LoginReqModel({
    this.email,
    this.password,
    this.name,
  });

  LoginReqModel copyWith({
    String? email,
    String? password,
    String? name,
  }) {
    return LoginReqModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toParam({
    required String userId,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userId;
    data['last_login_date'] = DateTime.now().toIso8601String();
    return data;
  }
}
