import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/features/priority_setting/domain/usecases/validate_weights_usecase.dart';

void main() {
  group('ValidateWeightsUseCase', () {
    late ValidateWeightsUseCase useCase;

    setUp(() {
      useCase = ValidateWeightsUseCase();
    });

    group('call()', () {
      test('should return success when weights sum to exactly 100%', () {
        // Arrange
        final weights = {'criterion1': 50.0, 'criterion2': 50.0};

        // Act
        final result = useCase(weights);

        // Assert
        expect(result.isValid, true);
        expect(result.errorMessage, isNull);
      });

      test(
        'should return success when weights sum to 100% within tolerance',
        () {
          // Arrange - 99.9999%
          final weights = {'criterion1': 50.0, 'criterion2': 49.9999};

          // Act
          final result = useCase(weights);

          // Assert
          expect(result.isValid, true);
          expect(result.errorMessage, isNull);
        },
      );

      test(
        'should return success when weights sum to 100.0001% (within tolerance)',
        () {
          // Arrange
          final weights = {'criterion1': 50.0, 'criterion2': 50.0001};

          // Act
          final result = useCase(weights);

          // Assert
          expect(result.isValid, true);
          expect(result.errorMessage, isNull);
        },
      );

      test('should return error when weights sum to 99%', () {
        // Arrange
        final weights = {'criterion1': 50.0, 'criterion2': 49.0};

        // Act
        final result = useCase(weights);

        // Assert
        expect(result.isValid, false);
        expect(result.errorMessage, contains('100%'));
      });

      test('should return error when weights sum to 101%', () {
        // Arrange
        final weights = {'criterion1': 50.0, 'criterion2': 51.0};

        // Act
        final result = useCase(weights);

        // Assert
        expect(result.isValid, false);
        expect(result.errorMessage, contains('100%'));
      });

      test('should return error for empty weights map', () {
        // Arrange
        final weights = <String, double>{};

        // Act
        final result = useCase(weights);

        // Assert
        expect(result.isValid, false);
        expect(result.errorMessage, contains('No weights'));
      });

      test('should work with 3 criteria summing to 100%', () {
        // Arrange
        final weights = {
          'criterion1': 33.33,
          'criterion2': 33.33,
          'criterion3': 33.34,
        };

        // Act
        final result = useCase(weights);

        // Assert
        expect(result.isValid, true);
      });

      test('should work with 10 criteria summing to 100%', () {
        // Arrange
        final weights = {for (int i = 0; i < 10; i++) 'criterion$i': 10.0};

        // Act
        final result = useCase(weights);

        // Assert
        expect(result.isValid, true);
      });
    });

    group('isValid()', () {
      test('should return true for valid weights', () {
        // Arrange
        final weights = {'criterion1': 60.0, 'criterion2': 40.0};

        // Act
        final isValid = useCase.isValid(weights);

        // Assert
        expect(isValid, true);
      });

      test('should return false for invalid weights', () {
        // Arrange
        final weights = {'criterion1': 50.0, 'criterion2': 40.0};

        // Act
        final isValid = useCase.isValid(weights);

        // Assert
        expect(isValid, false);
      });

      test('should return false for empty map', () {
        // Arrange
        final weights = <String, double>{};

        // Act
        final isValid = useCase.isValid(weights);

        // Assert
        expect(isValid, false);
      });
    });

    group('getWeightSum()', () {
      test('should return correct sum for two weights', () {
        // Arrange
        final weights = {'criterion1': 50.0, 'criterion2': 25.0};

        // Act
        final sum = useCase.getWeightSum(weights);

        // Assert
        expect(sum, 75.0);
      });

      test('should return 0 for empty map', () {
        // Arrange
        final weights = <String, double>{};

        // Act
        final sum = useCase.getWeightSum(weights);

        // Assert
        expect(sum, 0.0);
      });

      test('should return correct sum for many weights', () {
        // Arrange
        final weights = {for (int i = 0; i < 5; i++) 'criterion$i': 20.0};

        // Act
        final sum = useCase.getWeightSum(weights);

        // Assert
        expect(sum, 100.0);
      });
    });
  });
}
