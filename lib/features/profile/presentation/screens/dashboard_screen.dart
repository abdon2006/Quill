import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/constants/app_constants.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';
import 'package:quill/features/profile/presentation/widgets/back_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentStreak = 0;
  List<String> _finishedList = [];
  final List<BookEntity> _finishedBooks = [];
  int totalReadTime = 0;
  List<bool> weekdaysStreak = List.filled(8, false);

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

    setState(() {
      _currentStreak = streakCount;
    });
  }

  Future<void> _fetchFinishedBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? finishedBooks = prefs.getStringList('finished');
    if (finishedBooks != null) {
      setState(() => _finishedList = finishedBooks);
      print(
        '---------------- finished books now$_finishedList -------------------',
      );
    }
    if (_finishedList.isNotEmpty) {
      for (String id in _finishedList) {
        print('---------------- sending request to book $id');
        context.read<HomeBloc>().add(GetBookByIdEvent(bookId: id));
      }
    }
  }

  void _fetchWeekDays() async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now().toIso8601String().split('T').first;
    final day = DateTime.parse(today);
    final dayPositionInWeek = day.weekday;
    print(DateTime.now().weekday);
    for (var i = dayPositionInWeek; i > 0; i--) {
      final today = DateTime.now()
          .subtract(Duration(days: dayPositionInWeek - i))
          .toIso8601String()
          .split('T')
          .first;
      final isRead = prefs.getBool(today);
      setState(() => weekdaysStreak[i] = isRead ?? false);
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateStreak();
    _fetchFinishedBooks();
    _fetchWeekDays();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return PremiumAuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is GetBookByIdSuccess) {
                    final book = state.book;
                    final hours = (book.totalChunks * 1000) ~/ 200 ~/ 60;
                    setState(() {
                      _finishedBooks.add(book);
                      totalReadTime += hours;
                    });
                  }
                },
                child: SizedBox.shrink(),
              ),
              backButton(context, theme),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: AppTextStyles.displayLarge(context),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    StaggerdAnimation(
                      index: 1,
                      child: _streakCard(
                        context: context,
                        streakCount: _currentStreak,
                        theme: theme,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: StaggerdAnimation(
                            index: 2,
                            child: _finishedBooksCard(
                              theme: theme,
                              context: context,
                              booksLength: _finishedBooks.length,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: StaggerdAnimation(
                            index: 3,
                            child: _readingTimeCard(
                              theme: theme,
                              context: context,
                              readingTime: totalReadTime,
                            ),
                          ),
                        ),
                      ],
                    ),

                    StaggerdAnimation(
                      index: 4,
                      child: _weekCheckPointsStreakCard(
                        context: context,
                        theme: theme,
                        weekDays: weekdaysStreak,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _streakCard({
  required ColorScheme theme,
  required BuildContext context,
  required int streakCount,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.xxl,
    ),
    decoration: BoxDecoration(
      borderRadius: AppRadius.xl,
      color: theme.secondary,
      boxShadow: AppShadows.card,
    ),
    child: Row(
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedFire02,
          color: AppColors.darkTextPrimary,
          size: 48.sp,
        ),
        SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                '$streakCount  Day Streak',
                style: AppTextStyles.displayMedium(
                  context,
                ).copyWith(color: AppColors.darkTextPrimary),
              ),
              Text(
                'Keep it going  you\'re on a roll',
                style: AppTextStyles.defaultReading(
                  context,
                ).copyWith(color: AppColors.lightBgSurfaceAlt),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _finishedBooksCard({
  required ColorScheme theme,
  required BuildContext context,
  required int booksLength,
}) => Container(
  padding: EdgeInsets.all(AppSpacing.lg),
  margin: EdgeInsets.symmetric(vertical: AppSpacing.lg),
  decoration: BoxDecoration(
    borderRadius: AppRadius.xl,
    color: theme.surface,
    boxShadow: AppShadows.card,
  ),
  child: Column(
    children: [
      Text('Completed Books', style: AppTextStyles.heading2(context)),
      SizedBox(width: AppSpacing.lg),
      BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => AnimatedSwitcher(
          duration: AppDuration.normal,
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeIn,
          child: state is HomeLoading
              ? Skeletonizer(enabled: true, child: Text('12'))
              : Text(
                  '$booksLength',
                  style: AppTextStyles.displayLarge(
                    context,
                  ).copyWith(color: theme.secondary),
                ),
        ),
      ),
    ],
  ),
);

Widget _readingTimeCard({
  required ColorScheme theme,
  required BuildContext context,
  required int readingTime,
}) => Container(
  padding: EdgeInsets.all(AppSpacing.lg),
  margin: EdgeInsets.symmetric(vertical: AppSpacing.lg),
  decoration: BoxDecoration(
    borderRadius: AppRadius.xl,
    color: theme.surface,
    boxShadow: AppShadows.card,
  ),
  child: Column(
    children: [
      Text('Reading Time', style: AppTextStyles.heading2(context)),
      SizedBox(width: AppSpacing.lg),
      BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => AnimatedSwitcher(
          duration: AppDuration.normal,
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeIn,
          child: state is HomeLoading
              ? Skeletonizer(enabled: true, child: Text('12'))
              : Text(
                  '$readingTime',
                  style: AppTextStyles.displayLarge(
                    context,
                  ).copyWith(color: theme.secondary),
                ),
        ),
      ),
      Text('in hours', style: AppTextStyles.caption(context)),
    ],
  ),
);

Widget _weekCheckPointsStreakCard({
  required ColorScheme theme,
  required BuildContext context,
  required List<bool> weekDays,
}) {
  final today = DateTime.now().weekday;
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.xxl,
    ),
    decoration: BoxDecoration(borderRadius: AppRadius.xl, color: theme.surface),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('This Week', style: AppTextStyles.heading1(context)),

        SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(AppConstants.weekDays.length, (i) {
            final item = AppConstants.weekDays[i];
            bool isRead = weekDays[i + 1];
            bool isToday = (i + 1) == today;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StaggerdAnimation(
                  index: i * 2,
                  child: Container(
                    height: 24.w,
                    width: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRead
                          ? theme.secondary
                          : theme.onSurface.withValues(alpha: 0.1),
                      border: Border.all(
                        color: isToday && !isRead
                            ? theme.secondary
                            : theme.surface,
                      ),
                    ),
                  ),
                ),
                Text(item, style: AppTextStyles.defaultReading(context)),
              ],
            );
          }),
        ),
      ],
    ),
  );
}
