import 'dart:io';
import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../models/upload_models.dart';

class UploadApi {
  final Dio _dio = DioClient.instance.dio;

  /// 上传单个图片
  Future<ImageUploadResponse> uploadImage(File imageFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    final response = await _dio.post('/upload/image', data: formData);
    return ImageUploadResponse.fromJson(response.data);
  }

  /// 批量上传图片
  Future<List<ImageUploadResponse>> uploadImages(List<File> imageFiles) async {
    final List<MultipartFile> files = [];
    
    for (final file in imageFiles) {
      files.add(await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ));
    }

    final formData = FormData.fromMap({
      'files': files,
    });

    final response = await _dio.post('/upload/images', data: formData);
    return (response.data as List)
        .map((item) => ImageUploadResponse.fromJson(item))
        .toList();
  }

  /// 删除图片
  Future<void> deleteImage(String imageId) async {
    await _dio.delete('/images/$imageId');
  }

  /// 压缩图片
  Future<ImageUploadResponse> compressImage(CompressImageRequest request) async {
    final response = await _dio.post('/images/compress', data: request.toJson());
    return ImageUploadResponse.fromJson(response.data);
  }

  /// 获取图片信息
  Future<ImageInfo> getImageInfo(String imageId) async {
    final response = await _dio.get('/images/$imageId/info');
    return ImageInfo.fromJson(response.data);
  }

  /// 上传头像
  Future<ImageUploadResponse> uploadAvatar(File avatarFile) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        avatarFile.path,
        filename: avatarFile.path.split('/').last,
      ),
    });

    final response = await _dio.post('/upload/avatar', data: formData);
    return ImageUploadResponse.fromJson(response.data);
  }

  /// 上传视频（预留）
  Future<VideoUploadResponse> uploadVideo(File videoFile) async {
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        videoFile.path,
        filename: videoFile.path.split('/').last,
      ),
    });

    final response = await _dio.post('/upload/video', data: formData);
    return VideoUploadResponse.fromJson(response.data);
  }
}