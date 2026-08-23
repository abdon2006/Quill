import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_event.dart';

class BuildBottomActions extends StatefulWidget {
  final bool isInWishlist;
  final String bookId;
  const BuildBottomActions({
    super.key,
    required this.isInWishlist,
    required this.bookId,
  });

  @override
  State<BuildBottomActions> createState() => _BuildBottomActionsState();
}

class _BuildBottomActionsState extends State<BuildBottomActions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Row(
        children: [
          Expanded(
            child: AppButton.secondary(
              text: widget.isInWishlist
                  ? 'Remove From Library'
                  : 'Add to Library',
              icon: HugeIcons.strokeRoundedLibrary,
              onPressed: () {
                context.read<LibraryBloc>().add(
                  widget.isInWishlist
                      ? RemoveFromWishlistEvent(bookId: widget.bookId)
                      : AddToWishlistEvent(bookId: widget.bookId),
                );
              },
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          Expanded(
            child: AppButton.primary(
              text: 'Start Reading',
              icon: HugeIcons.strokeRoundedPlay,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
