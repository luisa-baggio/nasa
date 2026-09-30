class MarsPhoto {
  final int id;
  final int sol;
  final String earthDate;
  final String imageUrl;
  final String roverName;
  final String cameraName;
  final String cameraFullName;

  const MarsPhoto({
    required this.id,
    required this.sol,
    required this.earthDate,
    required this.imageUrl,
    required this.roverName,
    required this.cameraName,
    required this.cameraFullName,
  });

  factory MarsPhoto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rover =
        json['rover'] as Map<String, dynamic>? ?? {};

    final Map<String, dynamic> camera =
        json['camera'] as Map<String, dynamic>? ?? {};

    String imageUrl = json['img_src']?.toString() ?? '';

    // Algumas respostas antigas da API
    // possuem imagens com http://.
    // O Flutter pode bloquear esse tipo de endereço.
    if (imageUrl.startsWith('http://')) {
      imageUrl = imageUrl.replaceFirst('http://', 'https://');
    }

    return MarsPhoto(
      id: json['id'] ?? 0,
      sol: json['sol'] ?? 0,
      earthDate: json['earth_date']?.toString() ?? '',
      imageUrl: imageUrl,
      roverName: rover['name']?.toString() ?? '',
      cameraName: camera['name']?.toString() ?? '',
      cameraFullName: camera['full_name']?.toString() ?? '',
    );
  }
}
