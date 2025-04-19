import 'dart:convert';

class Account {
  int? id;
  String username;
  String password;
  int userId;
  String? lastLogin; // Thêm thuộc tính lastLogin
  String? status;    // Thêm thuộc tính status

  Account({
    this.id,
    required this.username,
    required this.password,
    required this.userId,
    this.lastLogin,
    this.status,
  });

  // Từ Map (dùng cho JSON từ server)
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      userId: map['userId'],
      lastLogin: map['lastLogin'],
      status: map['status'],
    );
  }

  // Từ JSON string
  factory Account.fromJSON(String jsonString) {
    return Account.fromMap(jsonDecode(jsonString));
  }

  // Thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'userId': userId,
      'lastLogin': lastLogin,
      'status': status,
    };
  }

  // Thành JSON string
  String toJSON() {
    return jsonEncode(toMap());
  }

  // CopyWith để tạo bản sao với các thuộc tính cập nhật
  Account copyWith({
    int? id,
    String? username,
    String? password,
    int? userId,
    String? lastLogin,
    String? status,
  }) {
    return Account(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      userId: userId ?? this.userId,
      lastLogin: lastLogin ?? this.lastLogin,
      status: status ?? this.status,
    );
  }
}