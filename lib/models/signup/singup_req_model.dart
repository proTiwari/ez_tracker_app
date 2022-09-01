class SignUpReqModel {
  String? email;
  String? password;
  String? name;
  String? confirmPassword;

  SignUpReqModel({
    this.email,
    this.password,
    this.name,
    this.confirmPassword,
  });

  SignUpReqModel copyWith({
    String? email,
    String? password,
    String? name,
    String? confirmPassword,
  }) {
    return SignUpReqModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  Map<String, dynamic> toParam({
    required String userId,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userId;
    data['email'] = email;
    data['name'] = name;
    data['created_date'] = DateTime.now().toIso8601String();

    return data;
  }
}
