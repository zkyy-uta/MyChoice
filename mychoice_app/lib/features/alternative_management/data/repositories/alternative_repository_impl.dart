import '../datasources/alternative_datasource.dart';
import '../../domain/entities/alternative.dart';
import '../../domain/repositories/alternative_repository.dart';
import '../../../../core/entities/user_plan.dart';

/// Alternative repository implementation
class AlternativeRepositoryImpl implements AlternativeRepository {
  final MockAlternativeDataSource _dataSource;

  AlternativeRepositoryImpl({required MockAlternativeDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<Alternative>> getCatalogAlternatives(String subcategoryId) async {
    return await _dataSource.getCatalogAlternatives(subcategoryId);
  }

  @override
  Future<bool> validateCount(int count, UserPlan plan) async {
    final maxAlternatives = plan.maxAlternativesPerDecision;
    return count <= maxAlternatives;
  }
}
