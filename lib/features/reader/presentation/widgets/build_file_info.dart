import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/features/library/data/models/library_book_display_model.dart';
import 'package:quill/features/reader/domain/usecases/params/update_book_params.dart';
import 'package:quill/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';
import 'package:quill/features/reader/presentation/widgets/build_image_source_choice.dart';
import 'package:quill/features/reader/presentation/widgets/build_selected_image.dart';

class BuildFileInfo extends StatefulWidget {
  final LibraryBookDisplayModel book;
  final void Function(XFile selectedImage) updateBookCoverUi;
  const BuildFileInfo({
    super.key,
    required this.book,
    required this.updateBookCoverUi,
  });

  @override
  State<BuildFileInfo> createState() => _BuildFileInfoState();
}

class _BuildFileInfoState extends State<BuildFileInfo> {
  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final progress =
        (widget.book.pages != null &&
            widget.book.currentPage != null &&
            widget.book.pages! > 0)
        ? widget.book.currentPage! / widget.book.pages!
        : 0.0;

    final progressLabel = '${(progress * 100).toStringAsFixed(0)}%';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: theme.surface.withValues(alpha: 0.72),
          borderRadius: AppRadius.lg,
          border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primary.withValues(alpha: 0.08),
                  ),
                  child: Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedImage01,
                      color: theme.primary,
                      size: 18.sp,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Book Cover',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                ),
                InkWell(
                  borderRadius: AppRadius.xl,
                  hoverColor: theme.primary,
                  onTap: () => showEditCoverImageBottomSheet(
                    context: context,
                    theme: theme,
                    onSave: (XFile newImage) {
                      setState(() {
                        selectedImage = newImage;
                      });
                      widget.updateBookCoverUi(newImage);
                      final params = UpdateBookParams(
                        bookId: widget.book.localId!,
                        title: widget.book.title,
                        author: widget.book.author,
                        currentPage: widget.book.currentPage!,
                        coverImagePath: newImage.path, isCoverImageChange: true,
                      );
                      context.read<ReaderBloc>().add(
                        UpdateBookEvent(params: params),
                      );
                    },
                  ),
                  child: Text(
                    'Change',
                    style: AppTextStyles.bodyMedium(
                      context,
                    ).copyWith(color: theme.primary),
                  ),
                ),
              ],
            ),

            if (widget.book.pages != null &&
                widget.book.currentPage != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Divider(color: theme.onSurface.withValues(alpha: 0.06)),
              const SizedBox(height: AppSpacing.lg),

              // Progress row
              Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primary.withValues(alpha: 0.08),
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedBookOpen02,
                        color: theme.primary,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reading Progress',
                          style: AppTextStyles.bodyMedium(context),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progress,
                                borderRadius: AppRadius.xl,
                                valueColor: AlwaysStoppedAnimation(
                                  theme.primary,
                                ),
                                backgroundColor: theme.onSurface.withValues(
                                  alpha: 0.08,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              progressLabel,
                              style: AppTextStyles.caption(context).copyWith(
                                color: theme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void showEditCoverImageBottomSheet({
  required BuildContext context,
  required ColorScheme theme,
  required void Function(XFile image) onSave,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.surface,
    builder: (sheetContext) {
      XFile? sheetImage;
      return StatefulBuilder(
        builder: (context, setSheetState) {
          Future<void> pickFromGallery() async {
            final XFile? image = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (image != null) {
              setSheetState(() => sheetImage = image);
            }
          }

          Future<void> pickFromCamera() async {
            final XFile? image = await ImagePicker().pickImage(
              source: ImageSource.camera,
            );
            if (image != null) {
              setSheetState(() => sheetImage = image);
            }
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl, // ← كده
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
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Set Your Cover',
                  style: AppTextStyles.displayMedium(
                    sheetContext,
                  ).copyWith(letterSpacing: 0),
                ),
                const SizedBox(height: AppSpacing.xl),
                BuildSelectedImage(image: sheetImage),
                const SizedBox(height: AppSpacing.xl),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildImageSourceChoice(
                      theme,
                      HugeIcons.strokeRoundedCamera01,
                      pickFromCamera,
                      'Camera',
                      sheetContext,
                    ),
                    buildImageSourceChoice(
                      theme,
                      HugeIcons.strokeRoundedGooglePhotos,
                      pickFromGallery,
                      'Gallery',
                      sheetContext,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                if (sheetImage != null)
                  AppButton.primary(
                    text: 'Save Cover',
                    onPressed: () {
                      onSave(sheetImage!); // بتبعت الـ path للـ parent
                      Navigator.pop(context);
                    },
                  ),
                const SizedBox(height: AppSpacing.lg),
                if (sheetImage == null)
                  Padding(
                    padding: EdgeInsetsGeometry.only(bottom: AppSpacing.md),
                    child: TextButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: Text(
                        'Never mind',
                        style: AppTextStyles.bodyMedium(sheetContext).copyWith(
                          color: theme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
