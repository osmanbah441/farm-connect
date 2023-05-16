import 'package:flutter/material.dart';

class ExpandedElevatedButton extends StatelessWidget {
  const ExpandedElevatedButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
  });

  final Widget? icon;
  final String label;
  final VoidCallback? onTap;

  ExpandedElevatedButton.inProgress(String label, {Key? key})
      : this(
          key: key,
          label: label,
          icon: Transform.scale(
            scale: 0.5,
            child: const CircularProgressIndicator(),
          ),
        );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: (icon != null)
          ? ElevatedButton.icon(
              onPressed: onTap,
              icon: icon!,
              label: Text(label),
            )
          : ElevatedButton(
              onPressed: onTap,
              child: Text(label),
            ),
    );
  }
}
