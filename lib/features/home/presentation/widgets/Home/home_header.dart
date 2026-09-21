import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeHeader extends StatefulWidget {
  final UserEntity user;
  const HomeHeader({super.key, required this.user});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int _currentStreak = 0;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future<void> _calculateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    int streakCount = 0;

    final todayKey = now.toIso8601String().split('T').first;
    final yesterdayKey = now
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .split('T')
        .first;

    final readToday = prefs.getBool(todayKey) ?? false;
    final readYesterday = prefs.getBool(yesterdayKey) ?? false;

    if (!readToday && !readYesterday) {
      streakCount = 0;
    } else {
      int dayOffset = readToday ? 0 : 1;

      while (true) {
        String dayKey = now
            .subtract(Duration(days: dayOffset))
            .toIso8601String()
            .split('T')
            .first;
        if (prefs.getBool(dayKey) ?? false) {
          streakCount++;
          dayOffset++;
        } else {
          break;
        }
      }
    }

    if (mounted) {
      setState(() {
        _currentStreak = streakCount;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateStreak();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final greeting = _getGreeting();
    final date = DateFormat(
      'EEEE, MMMM d',
    ).format(DateTime.now()).toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, ${widget.user.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.displayMedium(context),
        ),

        SizedBox(height: AppSpacing.xxs.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              date,
              style: AppTextStyles.label(
                context,
              ).copyWith(color: AppColors.lightTextMuted, letterSpacing: 1.1),
            ),

            AnimatedSwitcher(
              duration: AppDuration.normal,
              child: _currentStreak == 0
                  ? _buildEmptyStreakBadge(theme)
                  : _buildStreakBadge(theme),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakBadge(ColorScheme theme) {
    return Skeleton.ignore(
      child: Container(
        key: const ValueKey('has_streak'),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.smPlus.w,
          vertical: AppSpacing.xs.h,
        ),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.1),
          borderRadius: AppRadius.xl,
          border: Border.all(
            color: theme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedFire,
              size: 16.sp,
              color: theme.primary,
            ),
            SizedBox(width: AppSpacing.xs.w),
            Text(
              '$_currentStreak Day Streak',
              style: AppTextStyles.label(
                context,
              ).copyWith(color: theme.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStreakBadge(ColorScheme theme) {
    return Skeleton.ignore(
      child: Container(
        key: const ValueKey('no_streak'),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.smPlus.w,
          vertical: AppSpacing.xs.h,
        ),
        decoration: BoxDecoration(
          color: theme.onSurface.withValues(alpha: 0.05),
          borderRadius: AppRadius.xl,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedBookOpen01,
              size: 16.sp,
              color: theme.onSurface.withValues(alpha: 0.5),
            ),
            SizedBox(width: AppSpacing.xs.w),
            Text(
              'Start your streak',
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: theme.onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
