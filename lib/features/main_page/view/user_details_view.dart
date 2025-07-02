import '../../../core.dart';
import '../model/users_list_response_model.dart';
import '../view_model/main_view_model.dart';

class UserDetailsView extends StatefulWidget {
  final int userId;
  const UserDetailsView({super.key, required this.userId});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  UsersListResponseModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final viewModel = Provider.of<MainViewModel>(context, listen: false);
    final fetchedUser = await viewModel.getUserById(widget.userId);
    setState(() {
      user = fetchedUser;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("User Details"), backgroundColor: Colors.orange),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("User Details"), backgroundColor: Colors.orange),
        body: const Center(child: Text("User not found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(user!.name ?? "User Details"), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange,
                  child: Text(
                    user!.name != null && user!.name!.isNotEmpty ? user!.name![0].toUpperCase() : "?",
                    style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(user!.name ?? "-", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("@${user!.username ?? "-"}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const Divider(height: 24),
                _buildDetailRow(Icons.email, "Email", user!.email),
                _buildDetailRow(Icons.phone, "Phone", user!.phone),
                _buildDetailRow(Icons.language, "Website", user!.website),
                _buildDetailRow(
                  Icons.home,
                  "Address",
                  "${user!.address?.street ?? "-"}, ${user!.address?.suite ?? ""}, ${user!.address?.city ?? "-"} - ${user!.address?.zipcode ?? ""}",
                ),
                _buildDetailRow(
                  Icons.location_on,
                  "Geo Location",
                  "Lat: ${user!.address?.geo?.lat ?? "-"}, Lng: ${user!.address?.geo?.lng ?? "-"}",
                ),
                _buildDetailRow(Icons.business, "Company", user!.company?.name),
                _buildDetailRow(Icons.comment, "CatchPhrase", user!.company?.catchPhrase),
                _buildDetailRow(Icons.settings, "BS", user!.company?.bs),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value ?? "-", style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
