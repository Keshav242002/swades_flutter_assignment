import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _client;

  AuthRemoteDataSource(this._client);

  Future<UserModel> syncUser() async {
    final response = await _client.post(ApiConstants.authSync);
    return UserModel.fromJson(response.data);
  }
}
