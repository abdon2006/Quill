import 'package:quill/core/network/network_service.dart';
import 'package:quill/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:quill/features/auth/data/models/auth_model.dart';
import 'package:quill/features/auth/domain/auth_params.dart';
import 'package:quill/features/auth/domain/entities/auth_entity.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final NetworkService networkService;

  AuthRemoteDatasourceImpl({required this.networkService});
  @override
  Future<AuthEntity> signup(SignupParams params) async {
    final response = await networkService.dioPost('/auth/register', {
      "name": params.name,
      "email": params.email,
      "password": params.password,
      "passwordConfirm": params.passwordConfirm,
    });
    return AuthModel.fromJson(response.data);
  }

  @override
  Future<AuthEntity> login(LoginParams params) async {
    final response = await networkService.dioPost('/auth/login', {
      "email": params.email,
      "password": params.password,
    });
    return response.data;
  }
}
