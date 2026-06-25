import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../models/user_model.dart';

class PromotionalVideosScreen extends StatefulWidget {
  const PromotionalVideosScreen({super.key});

  @override
  State<PromotionalVideosScreen> createState() =>
      _PromotionalVideosScreenState();
}

class _PromotionalVideosScreenState extends State<PromotionalVideosScreen> {
  int _nowPlayingIndex = 0;

  final List<PromoVideo> _videos = [
    PromoVideo(id: '1', title: 'NABC 2026 Official Promo', thumbnailUrl: 'https://nabcapp.com/images/slider/1.jpg', videoUrl: '', duration: '2:45', description: 'The grand 46th NABC 2026 official promotional video.'),
    PromoVideo(id: '2', title: 'Bollywood Night Preview', thumbnailUrl: 'https://nabcapp.com/images/Vishal-Shekhar.png', videoUrl: '', duration: '1:32', description: 'A preview of the Bollywood night featuring Vishal-Shekhar.'),
    PromoVideo(id: '3', title: 'Saturday Night Spectacular', thumbnailUrl: 'https://nabcapp.com/images/Kaushiki.png', videoUrl: '', duration: '3:10', description: 'Highlights from last year\'s Saturday night special.'),
    PromoVideo(id: '4', title: 'Amjad Ali Khan — Sarod Maestro', thumbnailUrl: 'https://nabcapp.com/images/overseas-performers/Amjad.png', videoUrl: '', duration: '4:20', description: 'A glimpse of Amjad Ali Khan\'s mesmerizing sarod performance.'),
    PromoVideo(id: '5', title: 'NABC Film Festival 2025 Recap', thumbnailUrl: 'https://nabcapp.com/images/slider/2.jpg', videoUrl: '', duration: '5:00', description: 'Recap of the award-winning films from NABC Film Festival 2025.'),
    PromoVideo(id: '6', title: 'Welcome to NABC 2026', thumbnailUrl: 'https://nabcapp.com/images/slider/3.jpg', videoUrl: '', duration: '1:50', description: 'A warm welcome message from the NABC organizing committee.'),
  ];

  @override
  Widget build(BuildContext context) {
    final playing = _videos[_nowPlayingIndex];
    // Video screen always uses dark background for cinematic feel
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Promotional Videos'),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: Column(
        children: [
          _buildPlayer(context, playing),
          Expanded(
            child: Container(
              color: const Color(0xFF1A1A1A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        context.pagePad, 12, context.pagePad, 8),
                    child: Row(
                      children: [
                        const Icon(Icons.playlist_play,
                            color: Colors.white70, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'Playlist (${_videos.length} videos)',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: context.sp(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _videos.length,
                      itemBuilder: (_, i) =>
                          _buildPlaylistTile(context, _videos[i], i),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer(BuildContext context, PromoVideo video) {
    final playerH = context.hp(28).clamp(180.0, 260.0);
    return Container(
      height: playerH,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            video.thumbnailUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF1A1A1A),
              child: const Icon(Icons.movie_outlined,
                  color: Colors.white24, size: 60),
            ),
          ),
          Container(color: Colors.black45),
          Center(
            child: GestureDetector(
              onTap: () => _showPlayDialog(video),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow,
                    color: AppColors.primaryBlue, size: 36),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: context.pagePad,
            right: context.pagePad,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: context.sp(14),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  video.duration,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: context.sp(11),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accentRed,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_circle, color: Colors.white, size: 10),
                  SizedBox(width: 3),
                  Text(
                    'NOW PLAYING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile(BuildContext context, PromoVideo video, int index) {
    final isPlaying = _nowPlayingIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _nowPlayingIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: context.pagePad, vertical: 10),
        decoration: BoxDecoration(
          color: isPlaying
              ? AppColors.primaryBlue.withValues(alpha: 0.15)
              : Colors.transparent,
          border: isPlaying
              ? const Border(
                  left: BorderSide(color: AppColors.primaryBlue, width: 3))
              : null,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: context.wp(20).clamp(70.0, 90.0),
                height: 52,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF2A2A2A),
                        child: const Icon(Icons.movie_outlined,
                            color: Colors.white38),
                      ),
                    ),
                    Container(
                      color: Colors.black38,
                      child: Center(
                        child: Icon(
                          isPlaying ? Icons.equalizer : Icons.play_arrow,
                          color: isPlaying
                              ? AppColors.primaryBlue
                              : Colors.white60,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isPlaying ? AppColors.lightBlue : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: context.sp(12),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    video.duration,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: context.sp(10),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlayDialog(PromoVideo video) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          video.title,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        content: const Text(
          'Video playback requires a connection to the NABC media server. Please ensure you are connected to the internet.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: AppColors.lightBlue)),
          ),
        ],
      ),
    );
  }
}