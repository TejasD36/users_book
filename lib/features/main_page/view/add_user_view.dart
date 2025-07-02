import '../../../core.dart';
import '../model/users_list_response_model.dart';
import '../view_model/main_view_model.dart';

class AddUserView extends StatefulWidget {
  const AddUserView({super.key});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _streetController = TextEditingController();
  final _suiteController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _catchPhraseController = TextEditingController();
  final _bsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _streetController.dispose();
    _suiteController.dispose();
    _cityController.dispose();
    _zipcodeController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _companyNameController.dispose();
    _catchPhraseController.dispose();
    _bsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = Provider.of<MainViewModel>(context, listen: false);

    final newUser = UsersListResponseModel(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      website: _websiteController.text.trim(),
      address: Address(
        street: _streetController.text.trim(),
        suite: _suiteController.text.trim(),
        city: _cityController.text.trim(),
        zipcode: _zipcodeController.text.trim(),
        geo: Geo(lat: _latController.text.trim(), lng: _lngController.text.trim()),
      ),
      company: Company(
        name: _companyNameController.text.trim(),
        catchPhrase: _catchPhraseController.text.trim(),
        bs: _bsController.text.trim(),
      ),
    );

    await viewModel.addUser(newUser);

    if (mounted) {
      context.go(RouteName.homeView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add User"), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Consumer<MainViewModel>(
                builder: (_, vm, __) {
                  final isLoading = vm.usersListResponse.status == Status.loading;
                  return Column(
                    children: [
                      _buildTextField(_nameController, "Name", Icons.person, true),
                      _buildTextField(_usernameController, "Username", Icons.account_circle, true),
                      _buildTextField(_emailController, "Email", Icons.email, true, inputType: TextInputType.emailAddress),
                      _buildTextField(_phoneController, "Phone", Icons.phone, true, inputType: TextInputType.phone),
                      _buildTextField(_websiteController, "Website", Icons.language, false),

                      const Divider(height: 32),
                      const Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
                      _buildTextField(_streetController, "Street", Icons.location_on, false),
                      _buildTextField(_suiteController, "Suite", Icons.location_city, false),
                      _buildTextField(_cityController, "City", Icons.location_city, false),
                      _buildTextField(_zipcodeController, "Zip Code", Icons.pin_drop, false),

                      const Divider(height: 32),
                      const Text("Geo Location", style: TextStyle(fontWeight: FontWeight.bold)),
                      _buildTextField(_latController, "Latitude", Icons.map, false, inputType: TextInputType.number),
                      _buildTextField(_lngController, "Longitude", Icons.map, false, inputType: TextInputType.number),

                      const Divider(height: 32),
                      const Text("Company", style: TextStyle(fontWeight: FontWeight.bold)),
                      _buildTextField(_companyNameController, "Company Name", Icons.business, false),
                      _buildTextField(_catchPhraseController, "Catch Phrase", Icons.comment, false),
                      _buildTextField(_bsController, "BS", Icons.settings, false),

                      const SizedBox(height: 20),
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            icon: const Icon(Icons.save),
                            label: const Text("Add User"),
                            onPressed: _submit,
                          ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool isRequired, {
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(prefixIcon: Icon(icon, color: Colors.orange), labelText: label, border: const OutlineInputBorder()),
        validator: isRequired ? (value) => value == null || value.trim().isEmpty ? "$label is required" : null : null,
      ),
    );
  }
}
