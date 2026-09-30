import 'package:flutter/material.dart';

import '../model/rover.dart';
import 'explore_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Rover> rovers = [
    Rover(
      name: 'Curiosity',
      mission: 'Mars Science Laboratory',
      status: 'ATIVO',
      landingDate: '06/08/2012',
    ),
    Rover(
      name: 'Perseverance',
      mission: 'Mars 2020',
      status: 'ATIVO',
      landingDate: '18/02/2021',
    ),
    Rover(
      name: 'Opportunity',
      mission: 'Mars Exploration Rover',
      status: 'ENCERRADO',
      landingDate: '25/01/2004',
    ),
    Rover(
      name: 'Spirit',
      mission: 'Mars Exploration Rover',
      status: 'ENCERRADO',
      landingDate: '04/01/2004',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A12),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTop(context)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5A36),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'MISSÕES EM MARTE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildRoverCard(context, rovers[index]);
                }, childCount: rovers.length),
              ),
            ),

            SliverToBoxAdapter(child: _buildFooter()),
          ],
        ),
      ),
    );
  }

  Widget _buildTop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
      child: Container(
        height: 310,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF31120C), Color(0xFF15101B), Color(0xFF080A12)],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              top: -50,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF5A36).withOpacity(0.12),
                ),
              ),
            ),

            Positioned(
              right: 25,
              top: 35,
              child: Icon(
                Icons.public,
                size: 120,
                color: const Color(0xFFFF5A36).withOpacity(0.18),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5A36).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFFFF5A36).withOpacity(0.4),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Color(0xFFFF5A36),
                            ),
                            SizedBox(width: 7),
                            Text(
                              'NASA • MARS',
                              style: TextStyle(
                                color: Color(0xFFFF8A70),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  const Text(
                    'MARS\nEXPLORER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 43,
                      height: 0.95,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const SizedBox(
                    width: 270,
                    child: Text(
                      'Explore o planeta vermelho através '
                      'das lentes dos rovers da NASA.',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoverCard(BuildContext context, Rover rover) {
    final bool active = rover.status == 'ATIVO';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ExploreScreen(rover: rover)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF11141E),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF5A36), Color(0xFFFF8A3D)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.rocket_launch,
                color: Colors.white,
                size: 30,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        rover.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? Colors.green.withOpacity(0.12)
                              : Colors.grey.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          rover.status,
                          style: TextStyle(
                            color: active ? Colors.greenAccent : Colors.white38,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    rover.mission,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Pouso • ${rover.landingDate}',
                    style: const TextStyle(color: Colors.white30, fontSize: 11),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white30,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Icon(Icons.satellite_alt, color: Colors.white24, size: 28),
          const SizedBox(height: 10),
          const Text(
            'DADOS DA NASA',
            style: TextStyle(
              color: Colors.white30,
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'MARS PHOTO API',
            style: TextStyle(
              color: Colors.white.withOpacity(0.15),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
