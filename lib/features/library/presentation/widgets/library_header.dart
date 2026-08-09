import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/library/presentation/widgets/import_book_bottom_sheet.dart';

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({super.key});

  void _openImportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // ─────────────────────────────
      builder: (_) => const ImportBookBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Your Library',
                style: AppTextStyles.displayLarge(context),
              ),
            ),
            _HeaderIconButton(
              icon: HugeIcons.strokeRoundedSearch02,
              onTap: () {},
            ),
          ],
        ),

        SizedBox(height: 6.h),

        Text(
          'A quiet place for the stories you keep.',
          style: AppTextStyles.caption(context).copyWith(
            fontSize: 14.sp,
            color: theme.onSurface.withValues(alpha: 0.5),
            letterSpacing: 0.1,
          ),
        ),

        SizedBox(height: 22.h),

        GestureDetector(
          onTap: () => _openImportSheet(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primary,
                ),
                child: Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedFileAdd,
                    size: 19.sp,
                    color: theme.onPrimary,
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              Text(
                'Import a book',
                style: AppTextStyles.heading2(
                  context,
                ).copyWith(color: theme.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.onSurface.withValues(alpha: 0.05),
          ),
          child: Center(
            child: HugeIcon(
              icon: icon,
              size: 20.sp,
              color: theme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
