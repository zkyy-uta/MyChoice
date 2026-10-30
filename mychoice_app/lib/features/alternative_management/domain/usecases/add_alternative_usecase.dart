import '../entities/alternative.dart';
import '../repositories/alternative_repository.dart';
import '../../../../core/entities/user_plan.dart';
import '../../../../core/errors/app_exception.dart';

/// Use case for adding an alternative with quota enforcement
class AddAlternativeUseCase {
  final AlternativeRepository _repository;

  AddAlternativeUseCase({required AlternativeRepository repository})
    : _repository = repository;

  /// Add alternative if under quota limit
  Future<void> call(
    Alternative alternative,
    int currentCount,
    UserPlan plan,
  ) async {
    // Validate count before adding
    final isValid = await _repository.validateCount(currentCount + 1, plan);

    if (!isValid) {
      throw PlanLimitExceededException(
        message:
            'You have reached the maximum number of alternatives for your plan (${plan.maxAlternativesPerDecision}). Upgrade to Premium to add more.',
        feature: 'alternatives',
        limit: plan.maxAlternativesPerDecision,
        attempted: currentCount + 1,
      );
    }

    // If valid, the alternative can be added (actual addition handled by provider)
  }
}
