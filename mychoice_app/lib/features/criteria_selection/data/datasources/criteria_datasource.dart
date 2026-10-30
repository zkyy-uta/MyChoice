import '../../domain/entities/criterion.dart';

/// Data source for fetching criteria
abstract class CriteriaDataSource {
  /// Fetch suggested criteria for a given subcategory
  Future<List<Criterion>> getSuggestedCriteria(String subcategoryId);
}

/// Mock implementation that loads criteria from static data
class MockCriteriaDataSource implements CriteriaDataSource {
  // Suggested criteria by subcategory
  static final Map<String, List<Criterion>> _criteriaMap = {
    'laptop': [
      Criterion(
        id: 'crit_1',
        name: 'Price',
        type: CriterionType.cost,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_2',
        name: 'RAM',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_3',
        name: 'Storage',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_4',
        name: 'Processor Speed',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_5',
        name: 'Battery Life',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_6',
        name: 'Weight',
        type: CriterionType.cost,
        source: 'suggested',
      ),
    ],
    'phone': [
      Criterion(
        id: 'crit_7',
        name: 'Price',
        type: CriterionType.cost,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_8',
        name: 'Camera Quality',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_9',
        name: 'Screen Size',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_10',
        name: 'Battery Life',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_11',
        name: 'Storage',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
    ],
    'university': [
      Criterion(
        id: 'crit_12',
        name: 'Tuition Cost',
        type: CriterionType.cost,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_13',
        name: 'Campus Safety',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_14',
        name: 'Student Satisfaction',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_15',
        name: 'Job Placement Rate',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_16',
        name: 'Distance from Home',
        type: CriterionType.cost,
        source: 'suggested',
      ),
    ],
    'clothing': [
      Criterion(
        id: 'crit_17',
        name: 'Price',
        type: CriterionType.cost,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_18',
        name: 'Style/Design',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_19',
        name: 'Comfort',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_20',
        name: 'Durability',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
    ],
    'restaurant': [
      Criterion(
        id: 'crit_21',
        name: 'Price',
        type: CriterionType.cost,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_22',
        name: 'Food Quality',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_23',
        name: 'Service Quality',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_24',
        name: 'Ambiance',
        type: CriterionType.benefit,
        source: 'suggested',
      ),
      Criterion(
        id: 'crit_25',
        name: 'Distance',
        type: CriterionType.cost,
        source: 'suggested',
      ),
    ],
  };

  @override
  Future<List<Criterion>> getSuggestedCriteria(String subcategoryId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    final key = subcategoryId.toLowerCase();
    return _criteriaMap[key] ?? [];
  }
}
