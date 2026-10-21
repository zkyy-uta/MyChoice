import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/criteria_provider.dart';
import '../../domain/entities/criterion.dart';
import '../../data/repositories/criteria_repository_impl.dart';
import '../../data/datasources/criteria_datasource.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/dialogs/upgrade_prompt.dart';

/// Criteria selection screen
class CriteriaSelectionScreen extends StatefulWidget {
  final String subcategoryId;

  const CriteriaSelectionScreen({required this.subcategoryId, super.key});

  @override
  State<CriteriaSelectionScreen> createState() =>
      _CriteriaSelectionScreenState();
}

class _CriteriaSelectionScreenState extends State<CriteriaSelectionScreen> {
  late TextEditingController _customNameController;
  CriterionType _selectedType = CriterionType.benefit;
  bool _showCustomForm = false;

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
    final userProvider = context.read<UserProvider>();
    final planTier = (userProvider.user?.plan?.tier ?? 'basic') as String;

    return ProxyProvider<UserProvider, CriteriaProvider>(
      update: (context, userProvider, _) {
        return CriteriaProvider(
          repository: CriteriaRepositoryImpl(
            dataSource: MockCriteriaDataSource(),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Criteria'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<CriteriaProvider>(
          builder: (context, provider, _) {
            // Initialize on first build
            if (provider.suggestedCriteria.isEmpty) {
              provider.initialize(widget.subcategoryId, planTier);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Suggested Criteria
                  _SuggestedCriteria(provider: provider),
                  const SizedBox(height: AppSpacing.lg),

                  // Custom Criterion Form
                  _CustomCriterionSection(
                    showForm: _showCustomForm,
                    onToggle: () =>
                        setState(() => _showCustomForm = !_showCustomForm),
                    nameController: _customNameController,
                    selectedType: _selectedType,
                    onTypeChanged: (type) =>
                        setState(() => _selectedType = type),
                    onAdd: () => _handleAddCustomCriterion(context, provider),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // AI Suggestions (Premium only)
                  if (planTier.toLowerCase() == 'premium')
                    _AISuggestionsButton(provider: provider),
                  const SizedBox(height: AppSpacing.lg),

                  // Selected Criteria
                  if (provider.selectedCriteria.isNotEmpty) ...[
                    Text(
                      'Selected Criteria (${provider.selectedCriteria.length}/${provider.getMaxCriteriaCount()})',
                      style: AppTypography.sectionInnerTitle,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ..._buildSelectedCriteriaList(context, provider),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.selectedCriteria.isNotEmpty
                          ? () {
                              Navigator.of(
                                context,
                              ).pushNamed('/priority-input');
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
      ),
    );
  }

  List<Widget> _buildSelectedCriteriaList(
    BuildContext context,
    CriteriaProvider provider,
  ) {
    return provider.selectedCriteria.map((criterion) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Card(
          child: ListTile(
            title: Text(criterion.name),
            subtitle: Text(criterion.type.displayName),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              color: AppColors.error80,
              onPressed: () {
                provider.deselectCriterion(criterion.id);
              },
            ),
          ),
        ),
      );
    }).toList();
  }

  void _handleAddCustomCriterion(
    BuildContext context,
    CriteriaProvider provider,
  ) {
    if (_customNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a criterion name')),
      );
      return;
    }

    try {
      provider.addCustomCriterion(_customNameController.text, _selectedType);
      _customNameController.clear();
      setState(() => _showCustomForm = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Criterion added')));
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

/// Suggested criteria widget
class _SuggestedCriteria extends StatelessWidget {
  final CriteriaProvider provider;

  const _SuggestedCriteria({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Suggested Criteria', style: AppTypography.sectionInnerTitle),
        const SizedBox(height: AppSpacing.md),
        if (provider.suggestedCriteria.isEmpty)
          Center(
            child: Text(
              'No suggestions available',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: provider.suggestedCriteria.map((criterion) {
              final isSelected = provider.selectedCriteria.any(
                (c) => c.id == criterion.id,
              );

              return FilterChip(
                selected: isSelected,
                label: Text(criterion.name),
                avatar: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs),
                  child: Text(
                    criterion.type.shortName,
                    style: AppTypography.small.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onSelected: (selected) {
                  if (selected) {
                    provider.selectCriterion(criterion);
                  } else {
                    provider.deselectCriterion(criterion.id);
                  }
                },
              );
            }).toList(),
          ),
      ],
    );
  }
}

/// Custom criterion form widget
class _CustomCriterionSection extends StatelessWidget {
  final bool showForm;
  final VoidCallback onToggle;
  final TextEditingController nameController;
  final CriterionType selectedType;
  final Function(CriterionType) onTypeChanged;
  final VoidCallback onAdd;

  const _CustomCriterionSection({
    required this.showForm,
    required this.onToggle,
    required this.nameController,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Icon(
                  showForm ? Icons.expand_less : Icons.add,
                  color: AppColors.primary88,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Add Custom Criterion',
                  style: AppTypography.oneLiner.copyWith(
                    color: AppColors.primary88,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showForm) ...[
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Criterion name',
              prefixIcon: Icon(Icons.edit),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Type:', style: AppTypography.oneLiner),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: RadioListTile<CriterionType>(
                  title: const Text('Benefit'),
                  value: CriterionType.benefit,
                  groupValue: selectedType,
                  onChanged: (value) {
                    if (value != null) onTypeChanged(value);
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<CriterionType>(
                  title: const Text('Cost'),
                  value: CriterionType.cost,
                  groupValue: selectedType,
                  onChanged: (value) {
                    if (value != null) onTypeChanged(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAdd,
              child: const Text('Add Criterion'),
            ),
          ),
        ],
      ],
    );
  }
}

/// AI suggestions button widget
class _AISuggestionsButton extends StatelessWidget {
  final CriteriaProvider provider;

  const _AISuggestionsButton({required this.provider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: provider.aiSuggestionsState == AIState.loading
            ? null
            : () async {
                await provider.fetchAISuggestions();

                if (context.mounted &&
                    provider.aiSuggestionsState == AIState.loaded) {
                  // Show mock AI suggestions dialog
                  if (context.mounted) {
                    _showAISuggestionsDialog(context, provider);
                  }
                }
              },
        icon: provider.aiSuggestionsState == AIState.loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.auto_awesome),
        label: Text(
          provider.aiSuggestionsState == AIState.loading
              ? 'Generating...'
              : 'AI Suggest Criteria',
        ),
      ),
    );
  }

  void _showAISuggestionsDialog(
    BuildContext context,
    CriteriaProvider provider,
  ) {
    final mockSuggestions = [
      {'name': 'Processor Speed', 'confidence': 0.92},
      {'name': 'Graphics Quality', 'confidence': 0.87},
      {'name': 'Warranty Length', 'confidence': 0.78},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Suggestions'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: mockSuggestions.map((suggestion) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion['name'] as String,
                            style: AppTypography.oneLiner,
                          ),
                          Text(
                            'Confidence: ${((suggestion['confidence'] as double) * 100).toStringAsFixed(0)}%',
                            style: AppTypography.small.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add suggested criterion
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }
}
