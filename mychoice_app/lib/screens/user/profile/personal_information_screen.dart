import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../features/user_profile/presentation/providers/user_profile_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/mobile_background.dart';
import '../../../core/widgets/page_app_bar.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({this.isAdmin = false, super.key});

  final bool isAdmin;

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  bool _isPickingPhoto = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final provider = context.read<UserProfileProvider>();
    await provider.loadProfile();
    if (!mounted) return;

    final profile = provider.profile;
    if (profile == null) {
      _showMessage(provider.error ?? 'Gagal memuat profil.');
      return;
    }

    final nameParts = profile.name.trim().split(RegExp(r'\s+'));
    _firstNameController.text = nameParts.first;
    _lastNameController.text = nameParts.skip(1).join(' ');
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final name = [
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
    ].where((part) => part.isNotEmpty).join(' ');
    final provider = context.read<UserProfileProvider>();
    final saved = await provider.updateProfile(name: name);
    if (!mounted) return;

    if (!saved) {
      _showMessage(provider.error ?? 'Gagal menyimpan profil.');
      return;
    }

    _showMessage('Personal information saved.');
  }

  Future<void> _pickPhoto() async {
    setState(() => _isPickingPhoto = true);
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (image == null || !mounted) return;

      final provider = context.read<UserProfileProvider>();
      final saved = await provider.updateProfilePhoto(
        imageBytes: await image.readAsBytes(),
        fileName: image.name,
      );
      if (!mounted) return;
      _showMessage(
        saved
            ? 'Foto profil berhasil diperbarui.'
            : provider.error ?? 'Gagal memperbarui foto profil.',
      );
    } catch (error) {
      if (mounted) _showMessage('Gagal memilih foto: $error');
    } finally {
      if (mounted) setState(() => _isPickingPhoto = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<UserProfileProvider>();
    final authUser = context.watch<AuthProvider>().user;
    final profile = profileProvider.profile;
    const title = 'Personal Information';
    return MobileBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PageAppBar(title: title),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.primary20,
                    child: profileProvider.profile?.avatarUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 44,
                            color: AppColors.primaryDark,
                          )
                        : ClipOval(
                            child: Image.network(
                              profileProvider.profile!.avatarUrl!,
                              width: 84,
                              height: 84,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.person,
                                    size: 44,
                                    color: AppColors.primaryDark,
                                  ),
                            ),
                          ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      onPressed: profileProvider.isLoading || _isPickingPhoto
                          ? null
                          : _pickPhoto,
                      tooltip: 'Change profile photo',
                      icon: _isPickingPhoto
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.camera_alt),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary88,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _InformationField(
                    label: 'First Name',
                    controller: _firstNameController,
                    icon: Icons.person_outline,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'First name wajib diisi.'
                        : null,
                    textInputAction: TextInputAction.next,
                  ),
                  _InformationField(
                    label: 'Last Name',
                    controller: _lastNameController,
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                  ),
                  _ReadOnlyInformation(
                    label: 'Email',
                    value: authUser?.email ?? profile?.email ?? '',
                    icon: Icons.email_outlined,
                  ),
                  _ReadOnlyInformation(
                    label: 'Subscription',
                    value: profile == null
                        ? ''
                        : profile.plan == 'premium'
                        ? 'Premium'
                        : 'Basic',
                    icon: Icons.card_membership_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: profileProvider.isLoading ? null : _save,
                child: profileProvider.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ),
            if (profileProvider.error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                profileProvider.error!,
                style: AppTypography.small.copyWith(color: AppColors.error80),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyInformation extends StatelessWidget {
  const _ReadOnlyInformation({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              bottom: AppSpacing.xs,
            ),
            child: Text(label, style: AppTypography.small),
          ),
          InputDecorator(
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary88),
              filled: true,
              fillColor: Colors.white,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationField extends StatelessWidget {
  const _InformationField({
    required this.label,
    required this.controller,
    required this.icon,
    this.validator,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              bottom: AppSpacing.xs,
            ),
            child: Text(label, style: AppTypography.small),
          ),
          TextFormField(
            controller: controller,
            textInputAction: textInputAction,
            validator: validator,
            style: AppTypography.body.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary88),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
