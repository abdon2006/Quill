import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';

class BuildTopBar extends StatelessWidget {
  final ReaderPreferencesState state;
  final String bookTitle;
  final String bookAuthor;
  const BuildTopBar({
    super.key,
    required this.bookTitle,
    required this.bookAuthor,
    required this.state,
  });
  Color getBgColor(ReaderPreferencesState state, BuildContext context) {
    return switch (state.theme) {
      ReaderTheme.light => AppColors.lightBgSurface,
      ReaderTheme.dark => AppColors.darkBgSurface,
      ReaderTheme.system => Theme.of(context).colorScheme.surface,
    };
  }

  Color _getTextColor(ReaderPreferencesState state, BuildContext context) {
    return switch (state.theme) {
      ReaderTheme.dark => AppColors.darkTextPrimary,
      ReaderTheme.light => AppColors.lightTextPrimary,
      ReaderTheme.system =>
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: getBgColor(state, context),
        borderRadius: AppRadius.xl,
      ),
      child: Row(
        children: [
          _buildTopBarButton(
            icon: AppIcons.back,
            onTap: () => context.pop(),
            state: state,
            theme: theme,
            context: context,
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    bookAuthor,
                    style: AppTextStyles.caption(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    bookTitle,
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(state, context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          _buildTopBarButton(
            icon: AppIcons.bookmark,
            onTap: () {},
            state: state,
            theme: theme,
            context: context,
          ),

          const SizedBox(width: AppSpacing.sm),
          _buildTopBarButton(
            icon: HugeIcons.strokeRoundedMoreVertical,
            onTap: () {},
            state: state,
            theme: theme,
            context: context,
          ),
        ],
      ),
    );
  }
}

Widget _buildTopBarButton({
  required ReaderPreferencesState state,
  required List<List<dynamic>> icon,
  required void Function() onTap,
  required ColorScheme theme,
  required BuildContext context,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      customBorder: CircleBorder(),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle),
        padding: EdgeInsets.all(AppSpacing.sm),
        child: HugeIcon(
          icon: icon,
          color: theme.secondary.withValues(alpha: 0.7),
          // getIconsFgColor(state: state, context: context, theme: theme),
        ),
      ),
    ),
  );
}
