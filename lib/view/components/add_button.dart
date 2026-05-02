import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.accent,
    this.icon,
  });
  final VoidCallback? onPressed;
  final String label;

  final Color accent;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          shadowColor: accent.withAlpha(100),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 12,
          ),
        ),
        onPressed: onPressed,
        icon: Icon(
          icon ?? Icons.add,
          color: Colors.white,
          size: 20,
        ),
        iconAlignment: IconAlignment.start,
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
