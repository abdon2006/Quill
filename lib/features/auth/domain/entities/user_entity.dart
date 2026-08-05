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

  @override
  List<Object?> get props => [id, name, email, currentStreak, longestStreak];
}
