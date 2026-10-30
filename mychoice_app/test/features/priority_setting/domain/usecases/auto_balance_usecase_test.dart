import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/features/priority_setting/domain/usecases/auto_balance_usecase.dart';

void main() {
  group('AutoBalanceUseCase', () {
    late AutoBalanceUseCase useCase;

    setUp(() {
      useCase = AutoBalanceUseCase();
    });

    group('call()', () {
      test('should return empty map for empty input', () {
        // Arrange
        final weights = <String, double>{};

        // Act
        final result = useCase(weights);

        // Assert
        expect(result, isEmpty);
      });

      test('should return equal weights when all are zero', () {
        // Arrange
        final weights = {
          'criterion1': 0.0,
          'criterion2': 0.0,
          'criterion3': 0.0,
        };

        // Act
        final result = useCase(weights);

        // Assert
        expect(result.length, 3);
        result.forEach((key, value) {
          expect(value, closeTo(100.0 / 3, 0.01));
        });
      });

      test('should not change weights already summing to 100%', () {
        // Arrange
        final weights = {
          'criterion1': 40.0,
          'criterion2': 30.0,
          'criterion3': 30.0,
        };

        // Act
        final result = useCase(weights);

        // Assert
        expect(result['criterion1'], closeTo(40.0, 0.01));
        expect(result['criterion2'], closeTo(30.0, 0.01));
        expect(result['criterion3'], closeTo(30.0, 0.01));
      });

      test('should scale down weights summing to more than 100%', () {
        // Arrange
        final weights = {'criterion1': 100.0, 'criterion2': 100.0};

        // Act
        final result = useCase(weights);

        // Assert
        expect(result['criterion1'], closeTo(50.0, 0.01));
        expect(result['criterion2'], closeTo(50.0, 0.01));

        // Verify sum is 100%
        final sum = result.values.fold(0.0, (prev, elem) => prev + elem);
        expect(sum, closeTo(100.0, 0.01));
      });

      test('should scale up weights summing to less than 100%', () {
        // Arrange
        final weights = {'criterion1': 25.0, 'criterion2': 25.0};

        // Act
        final result = useCase(weights);

        // Assert
        expect(result['criterion1'], closeTo(50.0, 0.01));
        expect(result['criterion2'], closeTo(50.0, 0.01));

        // Verify sum is 100%
        final sum = result.values.fold(0.0, (prev, elem) => prev + elem);
        expect(sum, closeTo(100.0, 0.01));
      });

      test('should preserve proportions when balancing', () {
        // Arrange - A is 2x B initially
        final weights = {
          'criterion1': 40.0, // 2x of 20
          'criterion2': 20.0,
        };

        // Act
        final result = useCase(weights);

        // Assert - A should still be 2x B
        expect(
          result['criterion1']! / result['criterion2']!,
          closeTo(2.0, 0.01),
        );
      });

      test('should preserve proportions with 3 weights', () {
        // Arrange
        // A:B:C = 2:1:1
        final weights = {
          'criterion1': 20.0,
          'criterion2': 10.0,
          'criterion3': 10.0,
        };

        // Act
        final result = useCase(weights);

        // Assert
        expect(result['criterion1'], closeTo(50.0, 0.01)); // 2x of 25
        expect(result['criterion2'], closeTo(25.0, 0.01)); // 1x
        expect(result['criterion3'], closeTo(25.0, 0.01)); // 1x

        // Verify proportions
        expect(
          result['criterion1']! / result['criterion2']!,
          closeTo(2.0, 0.01),
        );
      });

      test('should handle negative weights by treating as zero', () {
        // Arrange
        final weights = {
          'criterion1': -10.0,
          'criterion2': -10.0,
          'criterion3': -10.0,
        };

        // Act
        final result = useCase(weights);

        // Assert - all should be distributed equally
        result.forEach((key, value) {
          expect(value, closeTo(100.0 / 3, 0.01));
        });
      });

      test('should handle mix of positive and negative weights', () {
        // Arrange
        final weights = {
          'criterion1': 50.0,
          'criterion2': -10.0,
          'criterion3': 50.0,
        };

        // Act
        final result = useCase(weights);

        // Assert
        // Only positive weights contribute, so 50:50
        expect(result['criterion1'], closeTo(50.0, 0.01));
        expect(result['criterion3'], closeTo(50.0, 0.01));

        // Sum should be 100%
        final sum = result.values.fold(0.0, (prev, elem) => prev + elem);
        expect(sum, closeTo(100.0, 0.01));
      });

      test('should handle very unequal weights', () {
        // Arrange
        final weights = {'criterion1': 1.0, 'criterion2': 99.0};

        // Act
        final result = useCase(weights);

        // Assert
        // Proportion should be preserved: 1:99
        expect(
          result['criterion1']! / result['criterion2']!,
          closeTo(1.0 / 99.0, 0.001),
        );
      });

      test('should work with many criteria', () {
        // Arrange
        final weights = {for (int i = 0; i < 10; i++) 'criterion$i': 5.0};

        // Act
        final result = useCase(weights);

        // Assert
        expect(result.length, 10);
        result.forEach((key, value) {
          expect(value, closeTo(10.0, 0.01));
        });

        // Verify sum is 100%
        final sum = result.values.fold(0.0, (prev, elem) => prev + elem);
        expect(sum, closeTo(100.0, 0.01));
      });
    });

    group('needsBalancing()', () {
      test('should return false when weights sum to 100%', () {
        // Arrange
        final weights = {'criterion1': 60.0, 'criterion2': 40.0};

        // Act
        final result = useCase.needsBalancing(weights);

        // Assert
        expect(result, false);
      });

      test('should return true when weights sum to less than 100%', () {
        // Arrange
        final weights = {'criterion1': 30.0, 'criterion2': 40.0};

        // Act
        final result = useCase.needsBalancing(weights);

        // Assert
        expect(result, true);
      });

      test('should return true when weights sum to more than 100%', () {
        // Arrange
        final weights = {'criterion1': 60.0, 'criterion2': 60.0};

        // Act
        final result = useCase.needsBalancing(weights);

        // Assert
        expect(result, true);
      });

      test('should return false for empty map', () {
        // Arrange
        final weights = <String, double>{};

        // Act
        final result = useCase.needsBalancing(weights);

        // Assert
        expect(result, false);
      });
    });

    group('getPercentage()', () {
      test('should return correct percentage of total', () {
        // Arrange
        final weights = {'criterion1': 50.0, 'criterion2': 50.0};

        // Act
        final percentage = useCase.getPercentage(50.0, weights);

        // Assert
        expect(percentage, closeTo(50.0, 0.01));
      });

      test('should return correct percentage for unequal weights', () {
        // Arrange
        final weights = {'criterion1': 25.0, 'criterion2': 75.0};

        // Act
        final percentage = useCase.getPercentage(25.0, weights);

        // Assert
        expect(percentage, closeTo(25.0, 0.01));
      });

      test('should return 0 for empty weights', () {
        // Arrange
        final weights = <String, double>{};

        // Act
        final percentage = useCase.getPercentage(10.0, weights);

        // Assert
        expect(percentage, 0.0);
      });
    });
  });
}
