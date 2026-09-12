import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/circle_button.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:share_plus/share_plus.dart';

Widget buildTopBar({required BuildContext context, required BookEntity book}) {
  final theme = Theme.of(context).colorScheme;

  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {
          return Row(
            children: [
              IgnorePointer(
                ignoring: state is HomeLoading,
                child: circleButton(
                  context,
                  icon: HugeIcons.strokeRoundedArrowLeft01,
                  background: theme.surface.withValues(alpha: 0.88),
                  foreground: theme.onSurface,
                  onTap: () => context.pop(),
                ),
              ),

              const Spacer(),

              circleButton(
                context,
                icon: HugeIcons.strokeRoundedShare08,
                background: theme.surface.withValues(alpha: 0.88),
                foreground: theme.onSurface,

                /// send simple Text maybe upgrade it in the future
                onTap: () => SharePlus.instance.share(
                  ShareParams(
                    text:
                        'Check out "${book.title}" by ${book.author} on Quill! 🪶\n\nStart reading now.',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
