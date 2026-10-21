import 'package:flutter/foundation.dart';
import '../../../../core/entities/user_plan.dart';

/// Access control provider for plan enforcement
class AccessControlProvider extends ChangeNotifier {
  final UserPlan _userPlan;

  AccessControlProvider({required UserPlan userPlan}) : _userPlan = userPlan;

  /// Check if user can add another alternative
  bool canAddAlternative(int currentCount) {
    return currentCount < _userPlan.maxAlternativesPerDecision;
  }

  /// Get remaining alternative quota
  int getAlternativeQuotaRemaining(int currentCount) {
    return _userPlan.maxAlternativesPerDecision - currentCount;
  }

  /// Get alternative quota message
  String getAlternativeQuotaMessage(int currentCount) {
    final remaining = getAlternativeQuotaRemaining(currentCount);
    if (remaining <= 0) {
      return 'Maximum alternatives reached (${_userPlan.maxAlternativesPerDecision} on ${_userPlan.tier} plan)';
    }
    return 'You can add $remaining more alternative${remaining != 1 ? 's' : ''}';
  }

  /// Check if user can add another criterion
  bool canAddCriterion(int currentCount) {
    return currentCount < _userPlan.maxCriteriaPerDecision;
  }

  /// Get remaining criterion quota
  int getCriterionQuotaRemaining(int currentCount) {
    return _userPlan.maxCriteriaPerDecision - currentCount;
  }

  /// Get criterion quota message
  String getCriterionQuotaMessage(int currentCount) {
    final remaining = getCriterionQuotaRemaining(currentCount);
    if (remaining <= 0) {
      return 'Maximum criteria reached (${_userPlan.maxCriteriaPerDecision} on ${_userPlan.tier} plan)';
    }
    return 'You can add $remaining more criterion${remaining != 1 ? 'a' : ''}';
  }

  /// Check if user can create decision
  bool canCreateDecision() {
    return true; // All plans can create decisions
  }

  /// Check if user can create what-if simulation
  bool canCreateWhatIf() {
    return true; // All plans can create what-if simulations
  }

  /// Check if plan is premium
  bool get isPremium => _userPlan.tier == 'Premium';

  /// Check if plan is basic
  bool get isBasic => _userPlan.tier == 'Basic';

  /// Get user tier
  String get planTier => _userPlan.tier.toString().split('.').last;
}
