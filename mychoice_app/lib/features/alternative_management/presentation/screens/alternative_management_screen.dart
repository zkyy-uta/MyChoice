import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alternative_provider.dart';
import '../../domain/entities/alternative.dart';
import '../../../access_control/presentation/providers/access_control_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/dialogs/upgrade_prompt.dart';

/// Alternative management screen (catalog and custom mode)
class AlternativeManagementScreen extends StatefulWidget {
  const AlternativeManagementScreen({super.key});

  @override
  State<AlternativeManagementScreen> createState() =>
      _AlternativeManagementScreenState();
}

class _AlternativeManagementScreenState
    extends State<AlternativeManagementScreen> {
  /// Controller used for both custom-mode input and catalog inline quick-add
  late TextEditingController _customNameController;

  @override
  void initState() {
    super.initState();
    _customNameController = TextEditingController();
  }

  @override
  void dispose() {
    _customNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Task 1: ensure Scaffold resizes so keyboard doesn't cause overflow
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Select Alternatives'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<AlternativeProvider>(
        builder: (context, alternativeProvider, _) {
          return SingleChildScrollView(
            // Task 1: dismiss keyboard when user drags the list
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
              // Task 1: push content above the keyboard
              bottom: AppSpacing.md +
                  MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mode toggle
                _ModeToggle(
                  catalogMode: alternativeProvider.catalogMode,
                  onToggle: () {
                    alternativeProvider.toggleMode();
                    _customNameController.clear();
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Content based on mode
                if (alternativeProvider.catalogMode)
                  _CatalogMode(
                    alternatives: alternativeProvider.catalogAlternatives,
                    selectedAlternatives:
                        alternativeProvider.selectedAlternatives,
                    onAdd: (alt) => _handleAdd(
                      context,
                      alternativeProvider,
                      catalogAlt: alt,
                    ),
                    onRemove: (altId) {
                      alternativeProvider.removeAlternative(altId);
                    },
                    // Task 2: inline quick-add controller for catalog mode
                    inlineCustomController: _customNameController,
                    onInlineCustomAdd: () => _handleAdd(
                      context,
                      alternativeProvider,
                      customName: _customNameController.text,
                    ),
                  )
                else
                  _CustomMode(
                    controller: _customNameController,
                    selectedAlternatives:
                        alternativeProvider.selectedAlternatives,
                    onAdd: () => _handleAdd(
                      context,
                      alternativeProvider,
                      customName: _customNameController.text,
                    ),
                    onRemove: (altId) {
                      alternativeProvider.removeAlternative(altId);
                    },
                  ),

                const SizedBox(height: AppSpacing.lg),

                // Selected count
                _CountBadge(count: alternativeProvider.alternativeCount),
                const SizedBox(height: AppSpacing.lg),

                // Next button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: alternativeProvider.isSelectionValid
                        ? () {
                            Navigator.of(
                              context,
                            ).pushNamed('/criteria-selection');
                          }
                        : null,
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Task 2: Unified add handler – works for both catalog items and custom names.
  /// Exactly one of [catalogAlt] or [customName] should be provided.
  void _handleAdd(
    BuildContext context,
    AlternativeProvider provider, {
    Alternative? catalogAlt,
    String? customName,
  }) async {
    Alternative alternative;

    if (catalogAlt != null) {
      // Catalog item passed directly
      alternative = catalogAlt;
    } else {
      // Custom name
      final name = (customName ?? '').trim();
      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter an alternative name')),
        );
        return;
      }
      alternative = Alternative(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        source: 'custom',
      );
    }

    try {
      final userProvider = context.read<UserProvider>();
      final userPlan = userProvider.user?.plan;

      if (userPlan == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User plan not found')));
        return;
      }

      await provider.addAlternative(alternative, userPlan);

      // Clear controller and unfocus if it was a custom add
      if (catalogAlt == null) {
        _customNameController.clear();
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      }
    } on PlanLimitExceededException catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => UpgradePromptDialog(
          title: 'Upgrade to Premium',
          message: e.message,
          onUpgrade: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Upgrade feature coming soon')),
            );
          },
        ),
      );
    }
  }
}

/// Mode toggle widget
class _ModeToggle extends StatelessWidget {
  final bool catalogMode;
  final VoidCallback onToggle;

  const _ModeToggle({required this.catalogMode, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: catalogMode ? AppColors.primary88 : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.buttonRadius - 1),
                bottomLeft: Radius.circular(AppSpacing.buttonRadius - 1),
              ),
              child: InkWell(
                onTap: catalogMode ? null : onToggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Center(
                    child: Text(
                      'Catalog',
                      style: AppTypography.buttonMedium.copyWith(
                        color: catalogMode
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: !catalogMode ? AppColors.primary88 : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppSpacing.buttonRadius - 1),
                bottomRight: Radius.circular(AppSpacing.buttonRadius - 1),
              ),
              child: InkWell(
                onTap: catalogMode ? onToggle : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Center(
                    child: Text(
                      'Custom',
                      style: AppTypography.buttonMedium.copyWith(
                        color: !catalogMode
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Catalog mode widget
/// Task 2: now also accepts an inline quick-add controller + callback
class _CatalogMode extends StatelessWidget {
  final List<Alternative> alternatives;
  final List<Alternative> selectedAlternatives;
  final Function(Alternative) onAdd;
  final Function(String) onRemove;

  /// Task 2: inline custom-add at the bottom of the catalog list
  final TextEditingController? inlineCustomController;
  final VoidCallback? onInlineCustomAdd;

  const _CatalogMode({
    required this.alternatives,
    required this.selectedAlternatives,
    required this.onAdd,
    required this.onRemove,
    this.inlineCustomController,
    this.onInlineCustomAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Available alternatives
        Text('Available Options', style: AppTypography.sectionInnerTitle),
        const SizedBox(height: AppSpacing.md),
        if (alternatives.isEmpty)
          Center(
            child: Text(
              'No alternatives available',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alternatives.length,
            itemBuilder: (context, index) {
              final alt = alternatives[index];
              final isSelected = selectedAlternatives.any(
                (a) => a.id == alt.id,
              );

              return _AlternativeListItem(
                alternative: alt,
                isSelected: isSelected,
                onAdd: () => onAdd(alt),
              );
            },
          ),

        // Task 2: inline quick-add custom section at the bottom of catalog
        if (inlineCustomController != null) ...[
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Not in the list? Add a custom option:',
            style: AppTypography.small.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: inlineCustomController,
                  decoration: const InputDecoration(
                    hintText: 'Enter custom name',
                    isDense: true,
                  ),
                  onSubmitted: (_) => onInlineCustomAdd?.call(),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton(
                onPressed: onInlineCustomAdd,
                child: const Text('Add'),
              ),
            ],
          ),
        ],

        const SizedBox(height: AppSpacing.lg),

        // Selected items
        if (selectedAlternatives.isNotEmpty) ...[
          Text('Selected Options', style: AppTypography.sectionInnerTitle),
          const SizedBox(height: AppSpacing.md),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedAlternatives.length,
            itemBuilder: (context, index) {
              final alt = selectedAlternatives[index];

              return Card(
                child: ListTile(
                  title: Text(alt.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.error80,
                    onPressed: () => onRemove(alt.id),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

/// Custom mode widget
class _CustomMode extends StatelessWidget {
  final TextEditingController controller;
  final List<Alternative> selectedAlternatives;
  final VoidCallback onAdd;
  final Function(String) onRemove;

  const _CustomMode({
    required this.controller,
    required this.selectedAlternatives,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input field
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter alternative name',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            ),
          ),
          onSubmitted: (_) => onAdd(),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Selected items
        if (selectedAlternatives.isNotEmpty) ...[
          Text('Your Options', style: AppTypography.sectionInnerTitle),
          const SizedBox(height: AppSpacing.md),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedAlternatives.length,
            itemBuilder: (context, index) {
              final alt = selectedAlternatives[index];

              return Card(
                child: ListTile(
                  title: Text(alt.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.error80,
                    onPressed: () => onRemove(alt.id),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

/// Alternative list item widget
class _AlternativeListItem extends StatelessWidget {
  final Alternative alternative;
  final bool isSelected;
  final VoidCallback onAdd;

  const _AlternativeListItem({
    required this.alternative,
    required this.isSelected,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(alternative.name),
        subtitle: alternative.specs != null && alternative.specs!.isNotEmpty
            ? Text(
                alternative.specs!.entries
                    .take(2)
                    .map((e) => '${e.key}: ${e.value}')
                    .join(' • '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: ElevatedButton(
          onPressed: isSelected ? null : onAdd,
          child: Text(isSelected ? 'Added' : 'Add'),
        ),
      ),
    );
  }
}

/// Count badge widget
class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary20,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.primary88),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary88),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Options Compared: $count',
            style: AppTypography.oneLiner.copyWith(
              color: AppColors.primary88,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
