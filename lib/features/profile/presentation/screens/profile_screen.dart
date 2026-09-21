import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/theme/app_toast.dart';
import 'package:quill/core/theme/cubit/theme_cubit.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';
import 'package:quill/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quill/features/auth/presentation/bloc/auth_event.dart';
import 'package:quill/features/auth/presentation/bloc/auth_state.dart';
import 'package:quill/features/profile/presentation/widgets/build_about_section.dart';
import 'package:quill/features/profile/presentation/widgets/build_import_section.dart';
import 'package:quill/features/profile/presentation/widgets/build_profile_header.dart';
import 'package:quill/features/profile/presentation/widgets/build_reading_section.dart';
import 'package:quill/features/profile/presentation/widgets/build_signout_button.dart';
import 'package:quill/features/profile/presentation/widgets/build_theme_section.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_cubit.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/reader_preferences_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserEntity? user;
  int selectedTheme = 0;
  @override
  void initState() {
    super.initState();
    context.read<ReaderPreferencesCubit>().loadPreferences();
    final savedTheme = context.read<ThemeCubit>().state.themeMode;
    selectedTheme = switch (savedTheme) {
      AppThemeMode.system => 0,
      AppThemeMode.light => 1,
      AppThemeMode.dark => 2,
    };
    context.read<AuthBloc>().add(FetchUserDataEvent(params: NoParams()));
  }

  void _handleThemeSelection() {
    switch (selectedTheme) {
      case 0:
        context.read<ThemeCubit>().setSystem();
        break;
      case 1:
        context.read<ThemeCubit>().setLight();
        break;
      case 2:
        context.read<ThemeCubit>().setDark();
        break;
    }
  }

  void _openPreferencesSheet(ColorScheme theme) => showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    builder: (_) => ReaderPreferencesSheet(
      onApply: () => appToast(
        context: context,
        label: 'Preferences Is Applied Successfully',
        description: 'check it in your book',
        theme: theme,
        icon: HugeIcons.strokeRoundedPreferenceHorizontal,
        isBlur: false,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return PremiumAuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: ListView(
              children: [
                MultiBlocListener(
                  listeners: [
                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is FetchUserDataSuccess) {
                          setState(() => user = state.userEntity);
                        }
                        if (state is SignoutSuccess) {
                          context.go(AppRoutes.choose);
                        }
                      },
                    ),
                  ],
                  child: SizedBox.shrink(),
                ),

                Text('Profile', style: AppTextStyles.displayLarge(context)),

                SizedBox(height: AppSpacing.lg),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    bool isLoading = state is AuthLoading;
                    return AnimatedSwitcher(
                      duration: AppDuration.normal,
                      switchInCurve: Curves.easeInOutCubic,
                      switchOutCurve: Curves.easeIn,
                      child: isLoading
                          ? Skeletonizer(
                              enabled: true,
                              child: BuildProfileHeader(
                                user: UserEntity.dummy(),
                              ),
                            )
                          : BuildProfileHeader(user: user),
                    );
                  },
                ),
                SizedBox(height: AppSpacing.xxxl),

                BuildThemeSection(
                  selectedTheme: selectedTheme,
                  onSelectTheme: (int i) => setState(() {
                    selectedTheme = i;
                    _handleThemeSelection();
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Divider(color: theme.onSurface.withValues(alpha: 0.1)),
                ),
                BuildReadingSection(
                  onPreferencesOpened: () => _openPreferencesSheet(theme),
                ),
                SizedBox(height: AppSpacing.sm),
                BuildImportSection(),
                SizedBox(height: AppSpacing.sm),
                BuildAboutSection(),
                SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Divider(color: theme.onSurface.withValues(alpha: 0.1)),
                ),
                BuildSignoutButton(),
                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
