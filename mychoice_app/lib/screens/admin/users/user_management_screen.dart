import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/admin_user.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';
import '../../../core/widgets/mobile_background.dart';
import '../../../core/widgets/page_app_bar.dart';
import '../../../features/admin_user_management/presentation/providers/admin_user_provider.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _searchController = TextEditingController();
  Set<AdminUserStatus> _selectedStatuses = AdminUserStatus.values.toSet();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AdminUserProvider>().loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AdminUser> _visibleUsers(List<AdminUser> users) {
    final query = _searchController.text.trim().toLowerCase();
    return users.where((user) {
      final matchesQuery =
          user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.id.toLowerCase().contains(query);
      return matchesQuery && _selectedStatuses.contains(user.status);
    }).toList();
  }

  Future<void> _showUserDetails(AdminUser user) async {
    final provider = context.read<AdminUserProvider>();
    final currentUserId = context.read<AuthProvider>().user?.id;
    final action = await showDialog<_UserAction>(
      context: context,
      builder: (context) => _UserDetailsDialog(
        user: user,
        canChangeRole: currentUserId != user.id,
        canChangeStatus: user.role != 'admin' && currentUserId != user.id,
      ),
    );
    if (action == null || !mounted) return;

    if (action.role != null && action.plan != null) {
      final updated = await provider.updateAccess(
        userId: user.id,
        role: action.role!,
        plan: action.plan!,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            updated
                ? 'Account access updated successfully.'
                : provider.error ?? 'Could not update account access.',
          ),
        ),
      );
      return;
    }

    final active = action.active;
    if (active == null || active == (user.status == AdminUserStatus.active)) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _AccountStatusConfirmationDialog(user: user, active: active),
    );
    if (confirmed != true || !mounted) return;

    final updated = await provider.setActive(userId: user.id, active: active);
    if (!mounted) return;
    // Akun yang baru dinonaktifkan harus tetap terlihat di daftar, termasuk
    // ketika filter status sedang diarahkan ke "Active" saja. Daftar tetap
    // dimuat ulang walau permintaan gagal agar status yang tampil sesuai data
    // di database.
    setState(() => _selectedStatuses = AdminUserStatus.values.toSet());
    await provider.loadUsers();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated
              ? active
                    ? 'Account activated successfully.'
                    : 'Account deactivated successfully.'
              : provider.error ?? 'Could not update account status.',
        ),
      ),
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
    final provider = context.watch<AdminUserProvider>();
    final users = _visibleUsers(provider.users);
    final allSelected =
        _selectedStatuses.length == AdminUserStatus.values.length;
    return MobileBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PageAppBar(
          title: 'User Management',
          showBackButton: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Manage MyChoice accounts here.',
                  textAlign: TextAlign.center,
                  style: AppTypography.extraSmallSemibold.copyWith(
                    color: AppColors.textTertiary,
                  ),
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
            if (provider.error != null && !provider.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        provider.error!,
                        style: AppTypography.extraSmallSemibold.copyWith(
                          color: AppColors.error80,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: provider.loadUsers,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null && provider.users.isEmpty
                  ? const SizedBox.shrink()
                  : users.isEmpty
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
        bottomNavigationBar: const AdminBottomNavigation(selectedIndex: 1),
      ),
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

class _UserDetailsDialog extends StatefulWidget {
  const _UserDetailsDialog({
    required this.user,
    required this.canChangeRole,
    required this.canChangeStatus,
  });

  final AdminUser user;
  final bool canChangeRole;
  final bool canChangeStatus;

  @override
  State<_UserDetailsDialog> createState() => _UserDetailsDialogState();
}

class _UserDetailsDialogState extends State<_UserDetailsDialog> {
  late String _role = widget.user.role;
  late String _plan = widget.user.plan;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
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
                    user.name.isEmpty
                        ? 'U'
                        : user.name.characters.first.toUpperCase(),
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
                    user.plan.toUpperCase(),
                    style: AppTypography.extraSmallSemibold.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.primaryDark,
                    size: 20,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _role,
              decoration: const InputDecoration(labelText: 'Account role'),
              items: const [
                DropdownMenuItem(value: 'user', child: Text('User')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: widget.canChangeRole
                  ? (value) {
                      if (value != null) setState(() => _role = value);
                    }
                  : null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _plan,
              decoration: const InputDecoration(labelText: 'Subscription plan'),
              items: const [
                DropdownMenuItem(value: 'basic', child: Text('Basic')),
                DropdownMenuItem(value: 'premium', child: Text('Premium')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _plan = value);
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _role == user.role && _plan == user.plan
                    ? null
                    : () => Navigator.of(
                        context,
                      ).pop(_UserAction.access(role: _role, plan: _plan)),
                child: const Text('Save role and plan'),
              ),
            ),
            if (widget.canChangeStatus) ...[
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(_UserAction.status(active: !isActive)),
                  icon: Icon(
                    isActive ? Icons.person_off_outlined : Icons.person_outline,
                    color: isActive ? AppColors.error80 : AppColors.primaryDark,
                  ),
                  label: Text(
                    isActive ? 'Deactivate Account' : 'Activate Account',
                    style: AppTypography.buttonMedium.copyWith(
                      color: isActive
                          ? AppColors.error80
                          : AppColors.primaryDark,
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
          ],
        ),
      ),
    );
  }
}

class _UserAction {
  const _UserAction.access({required this.role, required this.plan})
    : active = null;
  const _UserAction.status({required this.active}) : role = null, plan = null;

  final String? role;
  final String? plan;
  final bool? active;
}

class _AccountStatusConfirmationDialog extends StatelessWidget {
  const _AccountStatusConfirmationDialog({
    required this.user,
    required this.active,
  });

  final AdminUser user;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: active ? AppColors.primary20 : AppColors.error20,
            child: Icon(
              active ? Icons.person_outline : Icons.warning_rounded,
              color: active ? AppColors.primaryDark : AppColors.error80,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            active ? 'Activate account?' : 'Deactivate account?',
            textAlign: TextAlign.center,
            style: AppTypography.sectionInnerTitle,
          ),
          const SizedBox(height: 8),
          Text(
            active
                ? '${user.name} will be able to sign in to MyChoice again.'
                : '${user.name} will no longer be able to sign in to MyChoice. '
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
                child: Text(active ? 'Activate' : 'Deactivate'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
