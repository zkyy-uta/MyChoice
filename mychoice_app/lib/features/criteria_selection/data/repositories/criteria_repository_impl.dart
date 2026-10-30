import '../../domain/entities/criterion.dart';
import '../../domain/repositories/criteria_repository.dart';
import '../datasources/criteria_datasource.dart';

/// Implementation of CriteriaRepository
class CriteriaRepositoryImpl implements CriteriaRepository {
  final CriteriaDataSource dataSource;

  CriteriaRepositoryImpl({required this.dataSource});

  @override
  Future<List<Criterion>> getSuggestedCriteria(String subcategoryId) async {
    return await dataSource.getSuggestedCriteria(subcategoryId);
  }

  @override
  Future<bool> validateCount(int count, String planTier) async {
    // Basic plan: max 3 criteria
    // Premium plan: max 8 criteria
    if (planTier.toLowerCase() == 'basic') {
      return count <= 3;
    } else if (planTier.toLowerCase() == 'premium') {
      return count <= 8;
    }
    return true;
  }
}
