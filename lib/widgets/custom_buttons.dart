import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isLarge;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 32 : 24,
          vertical: isLarge ? 16 : 12,
        ),
        minimumSize: Size(0, isLarge ? 56 : 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isLarge ? 16 : 12),
        ),
        textStyle: TextStyle(
          fontSize: isLarge ? 18 : 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: isLarge ? 20 : 18),
                  const SizedBox(width: 8),
                ],
                Text(text),
              ],
            ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          Text(text),
        ],
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final bool isExtended;
  final String? label;
  final bool isSmall;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.isExtended = false,
    this.label,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label!),
        tooltip: tooltip,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      mini: isSmall,
      child: Icon(icon),
    );
  }
}

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final bool isSelected;

  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
    this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = isSelected ? AppColors.primary : (color ?? AppColors.textSecondary);
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: buttonColor, size: 24),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: buttonColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChipButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;
  final IconData? icon;

  const ChipButton({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: onPressed != null ? (_) => onPressed!() : null,
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.inputBorder,
        width: 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}