import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/core/widgets/app_text_field.dart';
import 'package:quill/features/library/data/models/library_book_display_model.dart';
import 'package:quill/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:quill/features/reader/presentation/bloc/reader_state.dart';
import 'package:quill/features/reader/presentation/widgets/build_cover.dart';
import 'package:quill/features/reader/presentation/widgets/build_delete_confirmation.dart';
import 'package:quill/features/reader/presentation/widgets/build_file_info.dart';
import 'package:quill/features/reader/presentation/widgets/build_identity.dart';
import 'package:quill/features/reader/presentation/widgets/build_top_bar.dart';

class LocalBookDetailsScreen extends StatefulWidget {
  final LibraryBookDisplayModel book;
  const LocalBookDetailsScreen({super.key, required this.book});

  @override
  State<LocalBookDetailsScreen> createState() => _LocalBookDetailsScreenState();
}

class _LocalBookDetailsScreenState extends State<LocalBookDetailsScreen> {
  XFile? newCover;
  final title = TextEditingController();
  final author = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<ReaderBloc, ReaderState>(
      listener: (context, state) {
        if (state is RemoveBookSuccess) {
          context.go(AppRoutes.library);
        }
      },
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                buildCover(
                  context,
                  newCover == null ? widget.book.coverImage : newCover!.path,
                ),

                const SizedBox(height: AppSpacing.xxl),

                BuildIdentity(
                  book: widget.book,
                  authorController: author,
                  titleController: title,
                ),

                const SizedBox(height: AppSpacing.xxl),

                BuildFileInfo(
                  book: widget.book,
                  updateBookCoverUi: (XFile selectedImage) {
                    setState(() {
                      newCover = selectedImage;
                    });
                  },
                ),

                const SizedBox(height: AppSpacing.xxl),

                buildDeleteSection(context, widget.book),

                const SizedBox(height: 150),
              ],
            ),

            buildTopBar(context),

            Positioned(
              left: 5.w,
              right: 5.w,
              bottom: 10.h,
              child: SafeArea(
                top: false,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: AppButton.primary(
                    text: 'Start Reading',
                    icon: HugeIcons.strokeRoundedPlay,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showEditBottomSheet({
  required BuildContext context,
  required ColorScheme theme,
  required String hint,
  required List<List<dynamic>> icon,
  required TextEditingController controller,
  required LibraryBookDisplayModel book,
  required void Function() onSave,
  required String content,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: theme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (context) {
      controller.text = content;
      return Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.onSurface.withValues(alpha: 0.15),
                borderRadius: AppRadius.lg,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Make it yours.',
              style: AppTextStyles.displayMedium(
                context,
              ).copyWith(letterSpacing: 0),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              hintText: hint,
              prefixIcon: icon,
              isPass: false,
              controller: controller,
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton.primary(text: 'Save', onPressed: onSave),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Never mind',
                style: AppTextStyles.bodyMedium(
                  context,
                ).copyWith(color: theme.onSurface.withValues(alpha: 0.45)),
              ),
            ),
          ],
        ),
      );
    },
  );
}
