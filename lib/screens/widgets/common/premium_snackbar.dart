import 'package:flutter/material.dart';

class PremiumSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    IconData icon = Icons.info_outline_rounded,
    Color? backgroundColor,
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final effectiveBackgroundColor = backgroundColor ?? 
        (isError 
            ? theme.colorScheme.error 
            : (isDark ? const Color(0xFF1E293B) : Colors.white));

    final textColor = isError 
        ? theme.colorScheme.onError 
        : (isDark || backgroundColor != null ? Colors.white : const Color(0xFF1E293B));

    final iconColor = isError 
        ? theme.colorScheme.onError 
        : (backgroundColor != null ? Colors.white : theme.colorScheme.primary);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        content: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: backgroundColor != null
                  ? Colors.transparent
                  : (isDark 
                      ? Colors.white.withOpacity(0.1) 
                      : Colors.black.withOpacity(0.05)),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isError ? Colors.redAccent : iconColor).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isError ? Colors.redAccent : iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                        ),
                      if (title != null) const SizedBox(height: 2),
                      /* Removed accent line */
                      Text(
                        message,
                        style: TextStyle(
                          color: textColor.withOpacity(0.9),
                          fontSize: title != null ? 13 : 15,
                          fontWeight: title != null ? FontWeight.w500 : FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
