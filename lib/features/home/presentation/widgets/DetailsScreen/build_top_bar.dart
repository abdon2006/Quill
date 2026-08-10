
  import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/circle_button.dart';

Widget buildTopBar(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            circleButton(
              context,
              icon: HugeIcons.strokeRoundedArrowLeft01,
              background: theme.surface.withValues(alpha: 0.88),
              foreground: theme.onSurface,
              onTap: () => context.pop(),
            ),

            const Spacer(),

            circleButton(
              context,
              icon: HugeIcons.strokeRoundedShare08,
              background: theme.surface.withValues(alpha: 0.88),
              foreground: theme.onSurface,
              onTap: () {},
            ),

            const SizedBox(width: AppSpacing.sm),

            circleButton(
              context,
              icon: HugeIcons.strokeRoundedBookmark03,
              background: theme.surface.withValues(alpha: 0.88),
              foreground: theme.onSurface,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
