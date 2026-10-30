import 'package:flutter/material.dart';

import '../../../core/models/admin_user.dart';
import '../../../core/models/admin_user_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';
import '../../../core/widgets/mobile_background.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _searchController = TextEditingController();
  Set<AdminUserStatus> _selectedStatuses = AdminUserStatus.values.toSet();

  List<AdminUser> get _users => AdminUserStore.instance.users.value;

  @override
  void initState() {
    super.initState();
    AdminUserStore.instance.users.addListener(_onUsersChanged);
  }

  void _onUsersChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AdminUserStore.instance.users.removeListener(_onUsersChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<AdminUser> get _visibleUsers {
    final query = _searchController.text.trim().toLowerCase();
    return _users.where((user) {
      final matchesQuery =
          user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.id.toLowerCase().contains(query);
      return matchesQuery && _selectedStatuses.contains(user.status);
    }).toList();
  }

  Future<void> _showUserDetails(AdminUser user) async {
    final shouldDeactivate = await showDialog<bool>(
      context: context,
      builder: (context) => _UserDetailsDialog(user: user),
    );
    if (shouldDeactivate != true || !mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DeactivateConfirmationDialog(user: user),
    );
    if (confirmed != true || !mounted) return;

    AdminUserStore.instance.update(
      user.copyWith(status: AdminUserStatus.inactive),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deactivated successfully')),
    );
  }

  Future<void> _showStatusFilter() async {
    final selected = await showModalBottomSheet<Set<AdminUserStatus>>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _StatusFilterSheet(initialSelection: _selectedStatuses),
    );
    if (selected != null) {
      setState(() => _selectedStatuses = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = _visibleUsers;
    final allSelected =
        _selectedStatuses.length == AdminUserStatus.values.length;
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'User Management',
          style: AppTypography.sectionInnerTitle.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        centerTitle: true,
      ),
      body: MobileBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'Manage MyChoice accounts here.',
                style: AppTypography.extraSmallSemibold.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Search name, email, or ID',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primaryDark,
                        ),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Clear search',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close),
                              ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: IconButton(
                      tooltip: 'Filter by status',
                      onPressed: _showStatusFilter,
                      icon: Icon(
                        Icons.tune,
                        color: allSelected
                            ? AppColors.primaryDark
                            : AppColors.error80,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                '${users.length} accounts found',
                style: AppTypography.extraSmallSemibold.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: users.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_search_outlined,
                              size: 44,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No users found',
                              style: AppTypography.smallSemibold,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try changing your search or status filter.',
                              textAlign: TextAlign.center,
                              style: AppTypography.extraSmallSemibold.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      itemCount: users.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return _UserCard(
                          user: user,
                          onDetailsTap: () => _showUserDetails(user),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavigation(selectedIndex: 1),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.onDetailsTap});

  final AdminUser user;
  final VoidCallback onDetailsTap;

  @override
  Widget build(BuildContext context) {
    final isActive = user.status == AdminUserStatus.active;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: AppColors.shadowLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: AppColors.primary20,
              child: Text(
                user.name.characters.first.toUpperCase(),
                style: AppTypography.smallSemibold.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: AppTypography.smallSemibold),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.extraSmallSemibold.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(user: user, isActive: isActive),
                const SizedBox(height: 4),
                Text(
                  user.plan,
                  style: AppTypography.extraSmallSemibold.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
            IconButton(
              tooltip: 'Show account details',
              onPressed: onDetailsTap,
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.user, required this.isActive});

  final AdminUser user;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.success20 : AppColors.error20,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: AppTypography.extraSmallSemibold.copyWith(
          color: isActive ? AppColors.primaryDark : AppColors.error80,
          fontSize: 9,
        ),
      ),
    );
  }
}

class _StatusFilterSheet extends StatefulWidget {
  const _StatusFilterSheet({required this.initialSelection});

  final Set<AdminUserStatus> initialSelection;

  @override
  State<_StatusFilterSheet> createState() => _StatusFilterSheetState();
}

class _StatusFilterSheetState extends State<_StatusFilterSheet> {
  late Set<AdminUserStatus> _selection;

  @override
  void initState() {
    super.initState();
    _selection = Set.of(widget.initialSelection);
  }

  void _toggleAll(bool selected) {
    setState(() {
      _selection = selected ? AdminUserStatus.values.toSet() : {};
    });
  }

  void _toggleStatus(AdminUserStatus status, bool selected) {
    setState(() {
      if (selected) {
        _selection.add(status);
      } else {
        _selection.remove(status);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allSelected = _selection.length == AdminUserStatus.values.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text('Account status', style: AppTypography.sectionInnerTitle),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey50,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    dense: true,
                    title: const Text('All'),
                    value: allSelected,
                    activeColor: AppColors.primaryDark,
                    onChanged: (value) => _toggleAll(value ?? false),
                  ),
                  CheckboxListTile(
                    dense: true,
                    title: const Text('Active'),
                    value: _selection.contains(AdminUserStatus.active),
                    activeColor: AppColors.primaryDark,
                    onChanged: (value) =>
                        _toggleStatus(AdminUserStatus.active, value ?? false),
                  ),
                  CheckboxListTile(
                    dense: true,
                    title: const Text('Inactive'),
                    value: _selection.contains(AdminUserStatus.inactive),
                    activeColor: AppColors.primaryDark,
                    onChanged: (value) =>
                        _toggleStatus(AdminUserStatus.inactive, value ?? false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(_selection),
                child: const Text('Apply filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserDetailsDialog extends StatelessWidget {
  const _UserDetailsDialog({required this.user});

  final AdminUser user;

  @override
  Widget build(BuildContext context) {
    final isActive = user.status == AdminUserStatus.active;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary20,
                  child: Text(
                    user.name.characters.first.toUpperCase(),
                    style: AppTypography.smallSemibold.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: AppTypography.smallSemibold),
                      Text(
                        user.email,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.extraSmallSemibold.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary20,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    user.plan,
                    style: AppTypography.extraSmallSemibold.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.primaryDark,
                    size: 20,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isActive
                    ? () => Navigator.of(context).pop(true)
                    : null,
                icon: Icon(
                  Icons.person_off_outlined,
                  color: isActive ? AppColors.error80 : AppColors.textTertiary,
                ),
                label: Text(
                  isActive ? 'Deactivate Account' : 'Account Deactivated',
                  style: AppTypography.buttonMedium.copyWith(
                    color: isActive
                        ? AppColors.error80
                        : AppColors.textTertiary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isActive ? AppColors.error20 : AppColors.border,
                  ),
                  backgroundColor: isActive
                      ? AppColors.error20
                      : AppColors.grey50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeactivateConfirmationDialog extends StatelessWidget {
  const _DeactivateConfirmationDialog({required this.user});

  final AdminUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.error20,
            child: Icon(
              Icons.warning_rounded,
              color: AppColors.error80,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Deactivate account?',
            textAlign: TextAlign.center,
            style: AppTypography.sectionInnerTitle,
          ),
          const SizedBox(height: 8),
          Text(
            '${user.name} will no longer be able to sign in to MyChoice. '
            'Their existing data will be kept.',
            textAlign: TextAlign.center,
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error80,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Deactivate'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
