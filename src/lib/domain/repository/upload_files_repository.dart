import 'package:dio/dio.dart';
import 'package:src/data/model/upload_photo.model.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/infrastructure/service/upload_files.dart';

abstract class UploadFilesRepository {
  Future<UploadPhotoModel> uploadPhoto(int userId, String filePath, String fileName);
}

class UploadFilesRepositoryImpl extends UploadFilesRepository {
  final UploadFilesService uploadFilesService;
  UploadFilesRepositoryImpl(this.uploadFilesService);

  @override
  Future<UploadPhotoModel> uploadPhoto(int userId, String filePath, String fileName) async {
    try {
      final request = await uploadFilesService.uploadPhoto(userId, filePath, fileName);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }
}
