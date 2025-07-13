import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /* ---- Controllers ---- */
  final _nameController    = TextEditingController();
  final _phoneController   = TextEditingController();
  final _addressController = TextEditingController();

  /* ---- UI state ---- */
  bool _isEditing = false;
  bool _isSaving  = false;

  /* ---- Firestore stream ---- */
  late final Stream<UserModel?> _userStream;

  @override
  void initState() {
    super.initState();
    final uid = context.read<AuthService>().currentUser!.id;
    _userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => snap.exists ? UserModel.fromJson(snap.data()!) : null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  /* ---- Save ---- */
  Future<void> _save(UserModel user) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final ok = await context.read<AuthService>().updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Profile updated' : 'Update failed'),
      ),
    );
    if (ok) setState(() => _isEditing = false);
  }

  /* ---- Logout ---- */
  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
        ],
      ),
    );
    if (confirmed == true) {
      await context.read<AuthService>().signOut();
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: StreamBuilder<UserModel?>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          // Populate controllers only once when not editing
          if (!_isEditing) {
            _nameController.text = user.name;
            _phoneController.text = user.phone;
            _addressController.text = user.address ?? '';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /* ---- Avatar ---- */
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.orange.shade100,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, size: 16),
                                onPressed: () {/* pick image */},
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /* ---- Fields ---- */
                  _field(
                    label: 'Full Name',
                    icon: Icons.person,
                    controller: _nameController,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  _field(
                    label: 'Email',
                    icon: Icons.email,
                    controller: TextEditingController(text: user.email),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  _field(
                    label: 'Phone',
                    icon: Icons.phone,
                    controller: _phoneController,
                    keyboard: TextInputType.phone,
                    validator: (v) => v!.length < 10 ? '10 digits' : null,
                  ),
                  const SizedBox(height: 16),
                  _field(
                    label: 'Address',
                    icon: Icons.location_on,
                    controller: _addressController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  /* ---- Buttons ---- */
                  if (_isEditing) ...[
                    CustomButton(
                      text: 'Save Changes',
                      onPressed: () => _save(user),
                      isLoading: _isSaving,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => setState(() => _isEditing = false),
                      child: const Text('Cancel'),
                    ),
                  ],

                  const SizedBox(height: 32),

                  /* ---- Menu ---- */
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Order History'),
                    onTap: () => Navigator.pushNamed(context, '/order-history'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text('Payment Methods'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & Support'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    onTap: _logout,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        readOnly: readOnly || !_isEditing,
        maxLines: maxLines,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
}