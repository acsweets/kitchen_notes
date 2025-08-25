class ImageUploadResponse {
  final String imageId;
  final String imageUrl;
  final String originalName;
  final int size;
  final DateTime uploadTime;

  ImageUploadResponse({
    required this.imageId,
    required this.imageUrl,
    required this.originalName,
    required this.size,
    required this.uploadTime,
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) => ImageUploadResponse(
    imageId: json['imageId'],
    imageUrl: json['imageUrl'],
    originalName: json['originalName'],
    size: json['size'],
    uploadTime: DateTime.parse(json['uploadTime']),
  );
}

class CompressImageRequest {
  final String imageId;
  final int quality;
  final int? maxWidth;
  final int? maxHeight;

  CompressImageRequest({
    required this.imageId,
    required this.quality,
    this.maxWidth,
    this.maxHeight,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'imageId': imageId,
      'quality': quality,
    };
    if (maxWidth != null) data['maxWidth'] = maxWidth;
    if (maxHeight != null) data['maxHeight'] = maxHeight;
    return data;
  }
}

class ImageInfo {
  final String imageId;
  final String originalName;
  final String mimeType;
  final int size;
  final int width;
  final int height;
  final DateTime uploadTime;

  ImageInfo({
    required this.imageId,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.width,
    required this.height,
    required this.uploadTime,
  });

  factory ImageInfo.fromJson(Map<String, dynamic> json) => ImageInfo(
    imageId: json['imageId'],
    originalName: json['originalName'],
    mimeType: json['mimeType'],
    size: json['size'],
    width: json['width'],
    height: json['height'],
    uploadTime: DateTime.parse(json['uploadTime']),
  );
}

class VideoUploadResponse {
  final String videoId;
  final String videoUrl;
  final String thumbnailUrl;
  final String originalName;
  final int size;
  final int duration;
  final DateTime uploadTime;

  VideoUploadResponse({
    required this.videoId,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.originalName,
    required this.size,
    required this.duration,
    required this.uploadTime,
  });

  factory VideoUploadResponse.fromJson(Map<String, dynamic> json) => VideoUploadResponse(
    videoId: json['videoId'],
    videoUrl: json['videoUrl'],
    thumbnailUrl: json['thumbnailUrl'],
    originalName: json['originalName'],
    size: json['size'],
    duration: json['duration'],
    uploadTime: DateTime.parse(json['uploadTime']),
  );
}