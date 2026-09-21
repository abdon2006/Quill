import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final int currentStreak;
  final int longestStreak;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.currentStreak,
    required this.longestStreak,
  });

  const UserEntity.dummy({
    this.id = '',
    this.name = 'abdallah',
    this.email = 'example123@gmail.com',
    this.currentStreak = 0,
    this.longestStreak = 0,
  });

  @override
  List<Object?> get props => [id, name, email, currentStreak, longestStreak];
}
