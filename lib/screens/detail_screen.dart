import 'package:flutter/material.dart';

import '../model/mars_photo.dart';

class DetailScreen extends StatelessWidget {
  final MarsPhoto photo;

  const DetailScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080A12),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'TRANSMISSÃO',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InteractiveViewer(
              child: Image.network(
                photo.imageUrl,
                width: double.infinity,
                height: 360,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const SizedBox(
                    height: 360,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF5A36),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 360,
                    color: const Color(0xFF11141E),
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white24,
                        size: 80,
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5A36).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'NASA • MARS',
                          style: TextStyle(
                            color: Color(0xFFFF8A70),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'DADOS DA\nTRANSMISSÃO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 25),

                  _buildInfo(Icons.rocket_launch, 'ROVER', photo.roverName),

                  _buildInfo(
                    Icons.public,
                    'SOL MARCIANO',
                    photo.sol.toString(),
                  ),

                  _buildInfo(
                    Icons.calendar_month,
                    'DATA TERRESTRE',
                    photo.earthDate,
                  ),

                  _buildInfo(Icons.camera_alt, 'CÂMERA', photo.cameraName),

                  _buildInfo(
                    Icons.info_outline,
                    'CÂMERA COMPLETA',
                    photo.cameraFullName,
                  ),

                  _buildInfo(Icons.tag, 'ID DA FOTO', photo.id.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(IconData icon, String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF11141E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5A36).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFFF5A36), size: 20),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white30,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value.isEmpty ? 'Não informado' : value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
