/// User subscription plan tier
enum UserPlanTier { guest, basic, premium, admin }

/// User subscription plan with quotas
class UserPlan {
  final UserPlanTier tier;
  final int maxAlternativesPerDecision;
  final int maxCriteriaPerDecision;
  final int maxWhatIfSimulations;
  final bool aiSuggestionsEnabled;
  final bool compareFeatureEnabled;
  final bool whatIfEnabled;
  final bool historySaveEnabled;
  final String? name;
  final String? description;

  const UserPlan({
    required this.tier,
    required this.maxAlternativesPerDecision,
    required this.maxCriteriaPerDecision,
    required this.maxWhatIfSimulations,
    required this.aiSuggestionsEnabled,
    required this.compareFeatureEnabled,
    required this.whatIfEnabled,
    required this.historySaveEnabled,
    this.name,
    this.description,
  });

  /// Get default plan for tier
  factory UserPlan.forTier(UserPlanTier tier) {
    switch (tier) {
      case UserPlanTier.guest:
        return const UserPlan(
          tier: UserPlanTier.guest,
          maxAlternativesPerDecision: 2,
          maxCriteriaPerDecision: 2,
          maxWhatIfSimulations: 0,
          aiSuggestionsEnabled: false,
          compareFeatureEnabled: false,
          whatIfEnabled: false,
          historySaveEnabled: false,
          name: 'Guest',
          description: 'Limited access for browsing',
        );
      case UserPlanTier.basic:
        return const UserPlan(
          tier: UserPlanTier.basic,
          maxAlternativesPerDecision: 3,
          maxCriteriaPerDecision: 3,
          maxWhatIfSimulations: 0,
          aiSuggestionsEnabled: false,
          compareFeatureEnabled: true,
          whatIfEnabled: false,
          historySaveEnabled: true,
          name: 'Basic',
          description: 'Essential decision-making features',
        );
      case UserPlanTier.premium:
        return const UserPlan(
          tier: UserPlanTier.premium,
          maxAlternativesPerDecision: 10,
          maxCriteriaPerDecision: 8,
          maxWhatIfSimulations: 50,
          aiSuggestionsEnabled: true,
          compareFeatureEnabled: true,
          whatIfEnabled: true,
          historySaveEnabled: true,
          name: 'Premium',
          description: 'Full access to all features',
        );
      case UserPlanTier.admin:
        return const UserPlan(
          tier: UserPlanTier.admin,
          maxAlternativesPerDecision: 100,
          maxCriteriaPerDecision: 50,
          maxWhatIfSimulations: 1000,
          aiSuggestionsEnabled: true,
          compareFeatureEnabled: true,
          whatIfEnabled: true,
          historySaveEnabled: true,
          name: 'Admin',
          description: 'Unrestricted access',
        );
    }
  }

  /// Check if feature is available in this plan
  bool isFeatureAvailable(String featureName) {
    switch (featureName) {
      case 'ai_suggestions':
        return aiSuggestionsEnabled;
      case 'compare':
        return compareFeatureEnabled;
      case 'what_if':
        return whatIfEnabled;
      case 'history_save':
        return historySaveEnabled;
      default:
        return false;
    }
  }

  @override
  String toString() =>
      'UserPlan($tier, max_alts: $maxAlternativesPerDecision, max_crit: $maxCriteriaPerDecision)';
}
