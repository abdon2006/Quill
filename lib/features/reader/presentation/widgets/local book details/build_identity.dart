import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/library/data/models/library_book_display_model.dart';
import 'package:quill/features/reader/domain/usecases/params/update_book_params.dart';
import 'package:quill/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';
import 'package:quill/features/reader/presentation/screens/local_book_details_screen.dart';
import 'package:quill/features/reader/presentation/widgets/local%20book%20details/edit_icon_button.dart';

class BuildIdentity extends StatefulWidget {
  final LibraryBookDisplayModel book;
  final TextEditingController titleController;
  final TextEditingController authorController;
  const BuildIdentity({
    super.key,
    required this.book,
    required this.titleController,
    required this.authorController,
  });

  @override
  State<BuildIdentity> createState() => _BuildIdentityState();
}

class _BuildIdentityState extends State<BuildIdentity> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.book.title,
                  style: AppTextStyles.displayMedium(
                    context,
                  ).copyWith(height: 1.08),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              editIconButton(
                context: context,
                onTap: () => showEditBottomSheet(
                  book: widget.book,
                  context: context,
                  controller: widget.titleController,
                  hint: 'Book Title',
                  icon: HugeIcons.strokeRoundedLabel,
                  onSave: () {
                    setState(() {
                      widget.book.title = widget.titleController.text;
                    });
                    final params = UpdateBookParams(
                      bookId: widget.book.localId!,
                      title: widget.titleController.text,
                      author: widget.book.author,
                      currentPage: widget.book.currentPage!,
                      coverImagePath: widget.book.coverImage ?? '', isCoverImageChange: false,
                    );
                    context.read<ReaderBloc>().add(
                      UpdateBookEvent(params: params),
                    );
                    Navigator.pop(context);
                  },
                  theme: theme,
                  content: widget.book.title,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          Row(
            children: [
              Text(
                widget.book.author,
                style: AppTextStyles.heading2(
                  context,
                ).copyWith(color: theme.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              editIconButton(
                context: context,
                onTap: () => showEditBottomSheet(
                  book: widget.book,
                  context: context,
                  controller: widget.authorController,
                  hint: 'Book Author',
                  icon: HugeIcons.strokeRoundedLabel,
                  onSave: () {
                    setState(() {
                      widget.book.author = widget.authorController.text;
                    });
                    final params = UpdateBookParams(
                      bookId: widget.book.localId!,
                      title: widget.book.title,
                      author: widget.authorController.text,
                      currentPage: widget.book.currentPage!,
                      coverImagePath: widget.book.coverImage ?? '', isCoverImageChange: false,
                    );
                    context.read<ReaderBloc>().add(
                      UpdateBookEvent(params: params),
                    );
                    Navigator.pop(context);
                  },
                  theme: theme,
                  content: widget.book.author,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
