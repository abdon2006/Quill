import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/core/widgets/show_app_snack_bar.dart';
import 'package:quill/features/reader/domain/usecases/params/upload_book_params.dart';
import 'package:quill/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';
import 'package:quill/features/reader/presentation/bloc/reader_state.dart';
import 'package:quill/features/reader/presentation/widgets/reader/text_animation.dart';

enum ImportState { idle, preview }

class ImportBookBottomSheet extends StatefulWidget {
  const ImportBookBottomSheet({super.key});
  @override
  State<ImportBookBottomSheet> createState() => _ImportBookBottomSheetState();
}

class _ImportBookBottomSheetState extends State<ImportBookBottomSheet> {
  ImportState _currentState = ImportState.idle;
  bool _isExtracting = false;
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'epub'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
        _currentState = ImportState.preview;
      });
    }
  }

  void _startImport() {
    final params = UploadBookParams(
      filePath: _selectedFile!.path!,
      fileName: _selectedFile!.name,
      fileExtension: _selectedFile!.extension ?? 'pdf',
    );
    context.read<ReaderBloc>().add(UploadBookEvent(book: params));
    setState(() {
      _isExtracting = true;
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return BlocConsumer<ReaderBloc, ReaderState>(
      listener: (context, state) {
        if (state is UploadBookSuccess) {
          showSnackBar(
            context,
            message: 'Your Book Is Ready Now',
            messageDisc: 'Ready to begin the journey.',
            icon: HugeIcons.strokeRoundedTick01,
          );
          Navigator.pop(context);
        } else if (state is ReaderFailure) {
          setState(() {
            _isExtracting = false;
            _currentState = ImportState.preview;
          });
          showSnackBar(
            context,
            message: 'Import Failed',
            messageDisc: 'Could not extract text from this file.',
            icon: HugeIcons.strokeRoundedWifiError01,
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            AnimatedOpacity(
              opacity: _isExtracting ? 1 : 0,
              duration: AppDuration.normal,
              child: TextAnimation(
                callBack: () {},
                messages: [
                  'Your Book Is Finding Its Place.',
                  'Just A moment',
                  'Preparing Your Book',
                  'One Step More',
                ],
                repeat: 10,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: AppDuration.normal,
                opacity: _isExtracting ? 0 : 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.xxl,
                  ),
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28.r),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
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
                          SizedBox(height: AppSpacing.xxl),
                          AnimatedSwitcher(
                            duration: AppDuration.normal,
                            child: switch (_currentState) {
                              ImportState.idle => _buildIdleContent(
                                theme: theme,
                                context: context,
                                pickFile: _pickFile,
                                key: ValueKey('idle'),
                              ),
                              ImportState.preview => _buildPreviewContent(
                                theme: theme,
                                context: context,
                                pickFile: _pickFile,
                                onImport: _startImport,
                                bookTitle: _selectedFile!.name,
                                bookSize: _formatFileSize(_selectedFile!.size),
                                isLoading: state is ReaderLoading,
                                key: ValueKey('preview'),
                              ),
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FormatBadge extends StatelessWidget {
  final String label;
  final ColorScheme theme;

  const _FormatBadge({required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.onSurface.withValues(alpha: 0.05),
        borderRadius: AppRadius.lg,
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium(
          context,
        ).copyWith(color: theme.onSurface.withValues(alpha: 0.55)),
      ),
    );
  }
}

Widget _buildIdleContent({
  required ColorScheme theme,
  required BuildContext context,
  required void Function() pickFile,
  required Key key,
}) {
  return Column(
    key: key,
    children: [
      Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.primary.withValues(alpha: 0.08),
        ),
        child: Center(
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedBook02,
            size: 30.sp,
            color: theme.primary,
          ),
        ),
      ),
      SizedBox(height: AppSpacing.xl),
      Text(
        'Bring something worth reading.',
        textAlign: TextAlign.center,
        style: AppTextStyles.displayMedium(
          context,
        ).copyWith(letterSpacing: 0.0),
      ),

      SizedBox(height: AppSpacing.sm),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Text(
          'Add a book to your personal reading space and make it yours.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: theme.onSurface.withValues(alpha: 0.55),
            height: 1.5,
          ),
        ),
      ),

      SizedBox(height: AppSpacing.xxl),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FormatBadge(label: 'PDF', theme: theme),
          SizedBox(width: 8.w),
          _FormatBadge(label: 'ePub', theme: theme),
        ],
      ),

      SizedBox(height: AppSpacing.xxl),

      AppButton.primary(
        text: 'Choose a File',
        onPressed: pickFile,
        icon: HugeIcons.strokeRoundedFolder02,
      ),

      SizedBox(height: AppSpacing.sm),

      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Maybe later',
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(color: theme.onSurface.withValues(alpha: 0.45)),
        ),
      ),
    ],
  );
}

Widget _buildPreviewContent({
  required ColorScheme theme,
  required BuildContext context,
  required void Function() pickFile,
  required void Function() onImport,
  required String bookTitle,
  required String bookSize,
  required bool isLoading,
  required Key key,
}) {
  return Column(
    key: key,
    children: [
      Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.primary.withValues(alpha: 0.08),
        ),
        child: Center(
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedBook04,
            size: 30.sp,
            color: theme.primary,
          ),
        ),
      ),
      SizedBox(height: AppSpacing.xl),
      Text(
        "Ready to find its place.",
        textAlign: TextAlign.center,
        style: AppTextStyles.displayMedium(
          context,
        ).copyWith(letterSpacing: 0.0),
      ),

      SizedBox(height: AppSpacing.md),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.onSurface.withValues(alpha: 0.04),
            borderRadius: AppRadius.xl,
            border: Border.all(
              color: theme.onSurface.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedFile02,
                  size: 24.sp,
                  color: theme.primary,
                ),
              ),

              SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      bookSize,
                      style: AppTextStyles.bodyMedium(
                        context,
                      ).copyWith(color: theme.onSurface.withValues(alpha: 0.5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      SizedBox(height: AppSpacing.xxl),

      AppButton.primary(
        text: isLoading ? "Importing..." : "Import Book",
        onPressed: onImport,
        isEnabled: !isLoading,
        icon: HugeIcons.strokeRoundedFolder01,
      ),

      SizedBox(height: AppSpacing.sm),

      TextButton(
        onPressed: pickFile,
        child: Text(
          "Choose a different file",
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(color: theme.onSurface.withValues(alpha: 0.45)),
        ),
      ),
    ],
  );
}
