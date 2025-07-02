import '../../../core.dart';
import '../view_model/main_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late MainViewModel _viewModel;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.getUsersList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<MainViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Users"), centerTitle: true, backgroundColor: Colors.orange),
      body: AppView(
        status: _viewModel.usersListResponse.status!,
        exception: _viewModel.usersListResponse.exception,
        child: _buildMainBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouteName.addUser);
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildMainBody() {
    // Apply search filter
    final filteredUsers =
        _viewModel.usersList.where((user) {
          final query = _searchQuery.toLowerCase();
          return user.name?.toLowerCase().contains(query) == true ||
              user.username?.toLowerCase().contains(query) == true ||
              user.email?.toLowerCase().contains(query) == true ||
              user.phone?.toLowerCase().contains(query) == true;
        }).toList();

    return Column(
      children: [
        // Search bar
        Container(
          color: Colors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: TextField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: "Search users...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
        ),

        // Grid of user cards
        Expanded(
          child:
              filteredUsers.isEmpty
                  ? const Center(child: Text("No users found."))
                  : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.push(RouteName.userDetails, extra: user.id);
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.orange.shade700,
                                        child: Text(
                                          user.name != null && user.name!.isNotEmpty ? user.name![0].toUpperCase() : '?',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          user.name ?? '-',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text("Username: ${user.username ?? '-'}", style: const TextStyle(fontSize: 12)),
                                  Text("Phone: ${user.phone ?? '-'}", style: const TextStyle(fontSize: 12)),
                                  Text("City: ${user.address?.city ?? '-'}", style: const TextStyle(fontSize: 12)),
                                  Text(
                                    "Company: ${user.company?.name ?? '-'}",
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
