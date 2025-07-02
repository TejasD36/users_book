import '../../../core.dart';
import '../model/users_list_response_model.dart';
import '../repository/main_repository.dart';

class MainViewModel extends ChangeNotifier {
  final MainRepository _repository = MainRepository();

  ApiResponse<List<UsersListResponseModel>> usersListResponse = ApiResponse.initial();
  List<UsersListResponseModel> usersList = [];

  //Database Service Methods
  Future<void> loadUsersFromDb() async {
    final dbUsers = await DatabaseService.instance.getAllUsers();
    if (dbUsers.isEmpty) {
    } else {
      usersList = dbUsers;
    }
  }

  Future<UsersListResponseModel?> getUserById(int id) async {
    return await DatabaseService.instance.getUserById(id);
  }

  Future<void> addUser(UsersListResponseModel user) async {
    usersListResponse = ApiResponse.loading();
    notifyListeners();

    int nextId = (await DatabaseService.instance.getMaxUserId()) + 1;
    user.id = nextId;

    await DatabaseService.instance.insertUser(user);

    usersList.add(user);

    usersListResponse = ApiResponse.completed(usersList);
    notifyListeners();
  }

  //API Call
  Future<void> getUsersList() async {
    await loadUsersFromDb();
    usersListResponse = ApiResponse.setResponse(ApiResponse.loading());
    notifyListeners();

    var response = await _repository.getUsersList();

    response.fold(
      (l) {
        usersListResponse = ApiResponse.setResponse(ApiResponse.error(l));
        notifyListeners();
      },
      (r) async {
        await DatabaseService.instance.upsertUsers(r);
        await loadUsersFromDb();

        usersListResponse = ApiResponse.setResponse(ApiResponse.completed(usersList));
        notifyListeners();
      },
    );
  }
}
