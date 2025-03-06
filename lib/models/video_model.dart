class VideoModel {
  final int? videoId;
  final String? videoIframe;
  final String? videoTipo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VideoModel({
    this.videoId,
    this.videoIframe,
    this.videoTipo,
    this.createdAt,
    this.updatedAt,
  });

  // Improved error handling and null safety with fromJson
  VideoModel.fromJson(Map<String, dynamic> json)
      : videoId = json['video_id'] as int?,
        videoIframe = json['video_iframe'] as String?,
        videoTipo = json['video_tipo'] as String?,
        createdAt = _parseDate(json['created_at']),
        updatedAt = _parseDate(json['updated_at']);

  // Helper function to handle DateTime parsing safely
  static DateTime? _parseDate(dynamic dateStr) {
    try {
      return dateStr != null ? DateTime.parse(dateStr) : null;
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }

  // Keeping toJson format as requested
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video_id'] = videoId;
    data['video_iframe'] = videoIframe;
    data['video_tipo'] = videoTipo;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    return data;
  }
}
