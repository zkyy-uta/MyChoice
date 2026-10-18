import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({this.isAdmin = false, super.key});

  final bool isAdmin;

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _dateOfBirthController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.isAdmin ? 'Admin' : 'Kim',
    );
    _lastNameController = TextEditingController(
      text: widget.isAdmin ? 'User' : 'Ryul',
    );
    _emailController = TextEditingController(
      text: widget.isAdmin ? 'admin@mychoice.com' : 'kimryul4sho@gmail.com',
    );
    _dateOfBirthController = TextEditingController(text: '18 September 2006');
    _phoneController = TextEditingController(text: '+62 821 5000 0000');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Personal information saved')));
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Personal Information';
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title, style: AppTypography.sectionInnerTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 38,
              backgroundColor: AppColors.primary20,
              child: Icon(Icons.person, size: 40, color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _InformationField(
            label: 'First Name',
            controller: _firstNameController,
            icon: Icons.person_outline,
          ),
          _InformationField(
            label: 'Last Name',
            controller: _lastNameController,
            icon: Icons.person_outline,
          ),
          _InformationField(
            label: 'Email',
            controller: _emailController,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          _InformationField(
            label: 'Date of Birth',
            controller: _dateOfBirthController,
            icon: Icons.calendar_month_outlined,
            readOnly: true,
          ),
          _InformationField(
            label: 'Phone',
            controller: _phoneController,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _save,
              child: const Text('Save Changes'),
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
    this.keyboardType,
    this.readOnly = false,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool readOnly;

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
          TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
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
