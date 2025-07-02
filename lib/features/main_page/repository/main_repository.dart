import '../../../core.dart';
import '../model/users_list_response_model.dart';

class MainRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<Either<AppException, List<UsersListResponseModel>>> getUsersList() async {
    return await _apiServices.getApi(
      ApiUrl.users,
      {},
      (data) => (data as List).map((e) => UsersListResponseModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
