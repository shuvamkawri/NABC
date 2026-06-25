import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../utils/responsive.dart';
import '../widgets/custom_app_bar.dart';

class PerformersScreen extends StatelessWidget {
  const PerformersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final performers = [
      Performer(
        id: '1',
        name: 'Amjad Ali Khan',
        specialty: 'Sarangi',
        imageUrl: 'https://via.placeholder.com/150?text=Amjad',
        bio: 'Legendary sarangi player',
        country: 'India',
      ),
      Performer(
        id: '2',
        name: 'Kaushiki Chakraborty',
        specialty: 'Hindustani Classical',
        imageUrl: 'https://nabcapp.com/images/Kaushiki.png',
        bio: 'Renowned classical singer',
        country: 'India',
      ),
      Performer(
        id: '3',
        name: 'Tanmoy Bose',
        specialty: 'Vocal',
        imageUrl: 'https://via.placeholder.com/150?text=Tanmoy',
        bio: 'Popular singer and composer',
        country: 'USA',
      ),
      Performer(
        id: '4',
        name: 'Taslima Nasrin',
        specialty: 'Writer',
        imageUrl: 'https://via.placeholder.com/150?text=Taslima',
        bio: 'Acclaimed author',
        country: 'Sweden',
      ),
      Performer(
        id: '5',
        name: 'Shantanu Moitra',
        specialty: 'Music Composer',
        imageUrl: 'https://via.placeholder.com/150?text=Shantanu',
        bio: 'Film music composer',
        country: 'India',
      ),
      Performer(
        id: '6',
        name: 'Avirup Sengupta',
        specialty: 'Actor',
        imageUrl: 'https://via.placeholder.com/150?text=Avirup',
        bio: 'Stage and film actor',
        country: 'India',
      ),
    ];

    final crossAxisCount = context.isTablet ? 3 : 2;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Performers',
        subtitle: 'Celebrity Artists',
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(context.pagePad),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: performers.length,
        itemBuilder: (context, index) =>
            _buildPerformerCard(context, performers[index]),
      ),
    );
  }

  Widget _buildPerformerCard(BuildContext context, Performer performer) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.cardRadius),
        child: InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Image.network(
                  performer.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: context.surfaceBg,
                    child: Center(
                      child: Icon(Icons.person,
                          color: context.textSecondary, size: 40),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        performer.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: context.sp(12),
                          color: context.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        performer.specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: context.sp(10),
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.public,
                              size: 11, color: context.textSecondary),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              performer.country,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: context.sp(10),
                                color: context.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}