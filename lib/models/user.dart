import 'package:dynadoc_front/network/user_requests.dart';

class User {
  final int? id;
  final String? name;
  final String email;
  final String? role;

  User({this.id, this.name, required this.email, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'role': role};
  }

  Future<bool> login(String password) async {
    final UserRequests userReq = UserRequests();
    bool success = await userReq.login(email, password);
    return success;
  }

  Future<bool> register(String password) async {
    final UserRequests userReq = UserRequests();
    bool success = await userReq.register(this, password);
    return success;
  }
}
