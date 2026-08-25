import 'package:equatable/equatable.dart';

class UploadBookParams extends Equatable {
  final String filePath;
  final String fileName;
  final String fileExtension;

  const UploadBookParams({
    required this.filePath,
    required this.fileName,
    required this.fileExtension,
  });

  @override
  List<Object?> get props => [filePath, fileName, fileExtension];
}
