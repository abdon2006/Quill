import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class BuildTopBar extends StatelessWidget {
  final String bookTitle;
  final String bookAuthor;
  const BuildTopBar({
    super.key,
    required this.bookTitle,
    required this.bookAuthor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: AppRadius.xl,
      ),
      child: Row(
        children: [
          _buildTopBarButton(
            bgColor: theme.surface.withValues(alpha: 0.07),
            fgColor: theme.onSurface,
            borderColor: theme.onSurface.withValues(alpha: 0.1),
            icon: AppIcons.back,
            onTap: () => context.pop(),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    bookTitle,
                    style: AppTextStyles.caption(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    bookTitle,
                    style: AppTextStyles.bodyMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          _buildTopBarButton(
            bgColor: theme.surface.withValues(alpha: 0.07),
            fgColor: theme.onSurface,
            borderColor: theme.onSurface.withValues(alpha: 0.1),
            icon: AppIcons.bookmark,
            onTap: () {},
          ),

          const SizedBox(width: AppSpacing.sm),
          _buildTopBarButton(
            bgColor: theme.surface.withValues(alpha: 0.07),
            fgColor: theme.onSurface,
            borderColor: theme.onSurface.withValues(alpha: 0.1),
            icon: HugeIcons.strokeRoundedMoreVertical,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

Widget _buildTopBarButton({
  required Color bgColor,
  required Color fgColor,
  required Color? borderColor,
  required List<List<dynamic>> icon,
  required void Function() onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      customBorder: CircleBorder(),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: borderColor != null ? Border.all(color: borderColor) : null,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(AppSpacing.sm),
        child: HugeIcon(icon: icon, color: fgColor),
      ),
    ),
  );
}
