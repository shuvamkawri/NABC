import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool compact;
  const StatusBadge({super.key, required this.status, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _resolve(status, context.textSecondary);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: compact ? 10 : 12),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: compact ? 9 : 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _resolve(String s, Color neutral) {
    switch (s) {
      case 'Checked':
        return (AppColors.successGreen, Icons.check_circle_outline);
      case 'Not Checked':
      case 'Not Applied':
        return (neutral, Icons.radio_button_unchecked);
      case 'Dispute':
        return (AppColors.warningYellow, Icons.warning_amber_outlined);
      case 'Resolved':
        return (AppColors.primaryBlue, Icons.verified_outlined);
      case 'On Time':
        return (AppColors.successGreen, Icons.check_circle_outline);
      case 'Delayed':
        return (AppColors.warningYellow, Icons.schedule_outlined);
      case 'Cancelled':
        return (AppColors.errorRed, Icons.cancel_outlined);
      case 'Confirmed':
      case 'Approved':
        return (AppColors.successGreen, Icons.done_all);
      case 'Partially Approved':
        return (AppColors.warningYellow, Icons.incomplete_circle);
      case 'Pending':
        return (AppColors.warningYellow, Icons.hourglass_empty_outlined);
      default:
        return (neutral, Icons.info_outline);
    }
  }
}