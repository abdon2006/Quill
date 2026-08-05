import 'package:quill/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.currentStreak,
    required super.longestStreak,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']['user'];
    return UserModel(
      id: user['_id'] as String,
      name: user['name'] as String,
      email: user['email'] as String,
      currentStreak: user['currentStreak'] as int,
      longestStreak: user['longestStreak'] as int,
    );
  }
}
