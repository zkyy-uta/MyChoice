import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Weight slider widget for input values 0-100%
class WeightSlider extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double? minValue;
  final double? maxValue;

  const WeightSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = 100,
    super.key,
  });

  @override
  State<WeightSlider> createState() => _WeightSliderState();
}

class _WeightSliderState extends State<WeightSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(WeightSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: AppTypography.oneLiner),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary20,
                borderRadius: BorderRadius.circular(AppSpacing.xs),
                border: Border.all(color: AppColors.primary88),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Text(
                '${_currentValue.toStringAsFixed(0)}%',
                style: AppTypography.buttonSmall.copyWith(
                  color: AppColors.primary88,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Slider(
          value: _currentValue,
          min: widget.minValue ?? 0,
          max: widget.maxValue ?? 100,
          divisions: 100,
          activeColor: AppColors.primary88,
          inactiveColor: AppColors.primary20,
          label: '${_currentValue.toStringAsFixed(0)}%',
          onChanged: (value) {
            setState(() => _currentValue = value);
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}
