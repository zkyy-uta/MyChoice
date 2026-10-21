import '../entities/criterion.dart';

/// Repository interface for criteria operations
abstract class CriteriaRepository {
  /// Fetch suggested criteria for a given subcategory
  Future<List<Criterion>> getSuggestedCriteria(String subcategoryId);

  /// Validate if count of criteria is within plan limits
  Future<bool> validateCount(int count, String planTier);
}
