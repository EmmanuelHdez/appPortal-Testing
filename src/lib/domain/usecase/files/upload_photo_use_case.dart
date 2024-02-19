import 'package:src/data/model/upload_photo.model.dart';
import 'package:src/domain/repository/upload_files_repository.dart';

class UploadPhotoUseCase {
  final UploadFilesRepository uploadFilesRepository;

  UploadPhotoUseCase(this.uploadFilesRepository);
  Future<UploadPhotoModel> call({required int userId, required String filePath, required String fileName}) async {
    return uploadFilesRepository.uploadPhoto(userId, filePath, fileName);
  }
}
