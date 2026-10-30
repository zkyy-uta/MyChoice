import '../entities/alternative.dart';
import '../../../../core/entities/user_plan.dart';

/// Alternative repository interface
abstract class AlternativeRepository {
  /// Get catalog alternatives for a specific subcategory
  Future<List<Alternative>> getCatalogAlternatives(String subcategoryId);

  /// Validate alternative count against plan limits
  Future<bool> validateCount(int count, UserPlan plan);
}
