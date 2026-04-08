import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

enum AppButtonVariant { primary, secondary, outlined, text, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final content = _buildContent();

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? AppDimensions.buttonHeight,
      child: _buildButton(content),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: variant == AppButtonVariant.outlined ||
                  variant == AppButtonVariant.text
              ? AppColors.primary
              : AppColors.textOnPrimary,
        ),
      );
    }

    final children = <Widget>[];

    if (leadingIcon != null) {
      children.addAll([
        Icon(leadingIcon, size: AppDimensions.iconMedium),
        const SizedBox(width: AppDimensions.spaceSmall),
      ]);
    }

    children.add(Text(label));

    if (trailingIcon != null) {
      children.addAll([
        const SizedBox(width: AppDimensions.spaceSmall),
        Icon(trailingIcon, size: AppDimensions.iconMedium),
      ]);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildButton(Widget content) {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
      case AppButtonVariant.secondary:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
      case AppButtonVariant.danger:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.textOnPrimary,
          ),
          onPressed: isLoading ? null : onPressed,
          child: content,
        );
    }
  }
}
