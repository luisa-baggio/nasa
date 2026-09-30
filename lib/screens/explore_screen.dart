import 'package:flutter/material.dart';

import '../model/mars_photo.dart';
import '../model/rover.dart';
import '../services/nasa_api_service.dart';
import 'detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  final Rover rover;

  const ExploreScreen({super.key, required this.rover});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final NasaApiService apiService = NasaApiService();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController solController = TextEditingController();

  List<MarsPhoto> photos = [];

  bool isLoading = false;

  String searchType = 'date';

  String? errorMessage;

  @override
  void dispose() {
    dateController.dispose();
    solController.dispose();
    super.dispose();
  }

  Future<void> searchPhotos() async {
    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      errorMessage = null;
      photos = [];
    });

    try {
      List<MarsPhoto> result;

      if (searchType == 'date') {
        final date = dateController.text.trim();

        if (date.isEmpty) {
          throw Exception('Digite uma data no formato AAAA-MM-DD.');
        }

        result = await apiService.getPhotosByDate(
          rover: widget.rover.name.toLowerCase(),
          date: date,
        );
      } else {
        final solText = solController.text.trim();

        if (solText.isEmpty) {
          throw Exception('Digite o número do Sol.');
        }

        final int? sol = int.tryParse(solText);

        if (sol == null || sol < 0) {
          throw Exception('Digite um número válido.');
        }

        result = await apiService.getPhotosBySol(
          rover: widget.rover.name.toLowerCase(),
          sol: sol,
        );
      }

      if (!mounted) return;

      setState(() {
        photos = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080A12),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.radar, color: Color(0xFFFF5A36)),
            const SizedBox(width: 10),
            Text(
              widget.rover.name.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMissionHeader(),

            const SizedBox(height: 25),

            _buildSearchPanel(),

            const SizedBox(height: 25),

            if (isLoading) _buildLoading(),

            if (errorMessage != null) _buildError(),

            if (!isLoading && errorMessage == null && photos.isNotEmpty)
              _buildResults(),

            if (!isLoading && errorMessage == null && photos.isEmpty)
              _buildEmpty(),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF24100B), Color(0xFF12131C)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5A36).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: Color(0xFFFF5A36),
                ),
              ),

              const SizedBox(width: 13),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MISSÃO',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'MARS EXPLORATION',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            widget.rover.mission,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _buildMiniStat('STATUS', widget.rover.status),
              const SizedBox(width: 10),
              _buildMiniStat('POUSO', widget.rover.landingDate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white30,
                fontSize: 9,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF11141E),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune, color: Color(0xFFFF5A36), size: 22),
              SizedBox(width: 10),
              Text(
                'CONSULTAR DADOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _buildModeButton(
                  'DATA',
                  Icons.calendar_today,
                  searchType == 'date',
                  () {
                    setState(() {
                      searchType = 'date';
                      errorMessage = null;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildModeButton(
                  'SOL',
                  Icons.public,
                  searchType == 'sol',
                  () {
                    setState(() {
                      searchType = 'sol';
                      errorMessage = null;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (searchType == 'date')
            TextField(
              controller: dateController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                'Data terrestre',
                'AAAA-MM-DD',
                Icons.calendar_month,
              ),
            ),

          if (searchType == 'sol')
            TextField(
              controller: solController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                'Sol marciano',
                'Ex: 1000',
                Icons.public,
              ),
            ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF5A36),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: isLoading ? null : searchPhotos,
              icon: const Icon(Icons.radar),
              label: const Text(
                'INICIAR BUSCA',
                style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white54),
      hintStyle: const TextStyle(color: Colors.white24),
      prefixIcon: Icon(icon, color: const Color(0xFFFF5A36)),
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFFF5A36)),
      ),
    );
  }

  Widget _buildModeButton(
    String title,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFF5A36)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFFFF5A36)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: selected ? Colors.white : Colors.white54,
            ),
            const SizedBox(width: 7),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white54,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            CircularProgressIndicator(color: Color(0xFFFF5A36)),
            SizedBox(height: 18),
            Text(
              'RECEBENDO DADOS DA NASA...',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: const Color(0xFF11141E),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.photo_camera_back_outlined,
            color: Colors.white24,
            size: 55,
          ),
          SizedBox(height: 15),
          Text(
            'Nenhuma transmissão encontrada',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Escolha uma data ou Sol para iniciar a busca.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white30, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'FOTOS RECEBIDAS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5A36).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${photos.length}',
                style: const TextStyle(
                  color: Color(0xFFFF8A70),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: photos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            return _buildPhotoCard(photos[index]);
          },
        ),
      ],
    );
  }

  Widget _buildPhotoCard(MarsPhoto photo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(photo: photo)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF11141E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    photo.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF5A36),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF181B25),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white24,
                              size: 45,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Imagem indisponível',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SOL ${photo.sol}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.cameraName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    photo.earthDate,
                    style: const TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
