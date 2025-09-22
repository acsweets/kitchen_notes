import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final int? maxLines;
  final bool enabled;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onClear;

  const SearchTextField({
    super.key,
    this.hintText = '搜索菜谱或食材...',
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.searchFill,
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textTertiary),
        prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textTertiary),
                onPressed: onClear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.inputFocused),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class NumberInputField extends StatelessWidget {
  final double value;
  final Function(double) onChanged;
  final double min;
  final double max;
  final double step;
  final String? unit;

  const NumberInputField({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.remove, color: AppColors.primary, size: 20),
              onPressed: value > min ? () => onChanged((value - step).clamp(min, max)) : null,
            ),
          ),
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              controller: TextEditingController(text: value.toString()),
              onChanged: (text) {
                final newValue = double.tryParse(text) ?? value;
                onChanged(newValue.clamp(min, max));
              },
            ),
          ),
          if (unit != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(unit!, style: const TextStyle(color: AppColors.textSecondary)),
            ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: AppColors.primary, size: 20),
              onPressed: value < max ? () => onChanged((value + step).clamp(min, max)) : null,
            ),
          ),
        ],
      ),
    );
  }
}