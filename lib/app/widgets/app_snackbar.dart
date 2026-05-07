import 'package:flutter/material.dart';
import 'package:refyn/theme/app_colors.dart';

enum SnackBarType { error, success, info, warning }

final class AppSnackBar {
  const AppSnackBar._();

  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    if (!context.mounted) {
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        _build(
          context,
          message: message,
          type: type,
          duration: duration,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
      );
  }

  static void error(BuildContext context, String message) {
    show(
      context,
      message,
      type: SnackBarType.error,
      duration: const Duration(seconds: 4),
    );
  }

  static void success(BuildContext context, String message) {
    show(context, message, type: SnackBarType.success);
  }

  static void info(BuildContext context, String message) {
    show(context, message, type: SnackBarType.info);
  }

  static void warning(BuildContext context, String message) {
    show(context, message, type: SnackBarType.warning);
  }

  static SnackBar _build(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    required Duration duration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final _SnackBarConfig config = _SnackBarConfig.fromType(type, context);

    return SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: duration,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      padding: EdgeInsets.zero,
      content: _AppSnackBarContent(
        message: message,
        config: config,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }
}

@immutable
final class _SnackBarConfig {
  const _SnackBarConfig({
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
    required this.borderColor,
    required this.actionColor,
  });

  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;
  final Color borderColor;
  final Color actionColor;

  factory _SnackBarConfig.fromType(SnackBarType type, BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color accent = isDark
        ? AppColors.brandPrimaryDark
        : AppColors.brandPrimary;

    return switch (type) {
      SnackBarType.error => _SnackBarConfig(
        backgroundColor: isDark
            ? const Color(0xFF3B1618)
            : const Color(0xFFFFE3E1),
        iconColor: isDark ? const Color(0xFFFFA8A0) : const Color(0xFFB3261E),
        textColor: isDark ? const Color(0xFFFFD9D5) : const Color(0xFF7A1C16),
        icon: Icons.error_outline_rounded,
        borderColor: AppColors.danger.withValues(alpha: 0.34),
        actionColor: AppColors.danger,
      ),
      SnackBarType.success => _SnackBarConfig(
        backgroundColor: isDark
            ? const Color(0xFF112A1D)
            : const Color(0xFFE3F6EA),
        iconColor: isDark ? const Color(0xFF7FE0A8) : const Color(0xFF1F8A4C),
        textColor: isDark ? const Color(0xFFC8F2D8) : const Color(0xFF155D33),
        icon: Icons.check_circle_outline_rounded,
        borderColor: AppColors.success.withValues(alpha: 0.36),
        actionColor: AppColors.success,
      ),
      SnackBarType.warning => _SnackBarConfig(
        backgroundColor: isDark
            ? const Color(0xFF34250B)
            : const Color(0xFFFFF1CC),
        iconColor: isDark ? const Color(0xFFFFD36A) : const Color(0xFF946200),
        textColor: isDark ? const Color(0xFFFFE7A6) : const Color(0xFF6B4700),
        icon: Icons.warning_amber_rounded,
        borderColor: const Color(0xFFE2AE2B).withValues(alpha: 0.42),
        actionColor: const Color(0xFFD58A00),
      ),
      SnackBarType.info => _SnackBarConfig(
        backgroundColor: isDark
            ? const Color(0xFF1A2138)
            : const Color(0xFFFFE8DB),
        iconColor: accent,
        textColor: isDark ? const Color(0xFFFFD9C8) : const Color(0xFF6D3116),
        icon: Icons.info_outline_rounded,
        borderColor: accent.withValues(alpha: 0.34),
        actionColor: accent,
      ),
    };
  }
}

class _AppSnackBarContent extends StatelessWidget {
  const _AppSnackBarContent({
    required this.message,
    required this.config,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final _SnackBarConfig config;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: config.borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: <Widget>[
          Icon(config.icon, color: config.iconColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: config.textColor,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          if (actionLabel != null && onAction != null) ...<Widget>[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: config.actionColor,
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
