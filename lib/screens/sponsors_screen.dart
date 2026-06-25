import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/event_model.dart';
import '../utils/responsive.dart';
import '../widgets/custom_app_bar.dart';

class SponsorsScreen extends StatelessWidget {
  const SponsorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sponsors = [
      Sponsor(
        id: '1',
        name: 'P. C. Chandra Jewellers',
        logo: 'https://via.placeholder.com/200?text=PC+Chandra',
        website: 'www.pcchandraindia.com',
        sponsorshipLevel: 'Gold',
        description: 'Premium jewelry retailer',
      ),
      Sponsor(
        id: '2',
        name: 'Bengal Jewellery',
        logo: 'https://via.placeholder.com/200?text=Bengal',
        website: 'www.bengaljewellery.com',
        sponsorshipLevel: 'Gold',
        description: 'Authentic Bengali jewelry',
      ),
      Sponsor(
        id: '3',
        name: 'Srijan Residency Limited',
        logo: 'https://via.placeholder.com/200?text=Srijan',
        website: 'www.srijanrealty.com',
        sponsorshipLevel: 'Gold',
        description: 'Real estate development',
      ),
    ];

    final crossAxisCount = context.isTablet ? 3 : 2;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Sponsors',
        subtitle: 'NABC 2026',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gold Sponsors',
              style: TextStyle(
                fontSize: context.sp(19),
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: sponsors.length,
              itemBuilder: (context, index) =>
                  _buildSponsorCard(context, sponsors[index]),
            ),
            const SizedBox(height: 32),

            Container(
              padding: EdgeInsets.all(context.cardPad + 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(context.cardRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Become a Sponsor',
                    style: TextStyle(
                      fontSize: context.sp(17),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Be a proud sponsor of NABC 2026 and showcase your brand to thousands of attendees!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: context.sp(13),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/registration'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryBlue,
                    ),
                    child: Text(
                      'Register as Sponsor',
                      style: TextStyle(fontSize: context.sp(13)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsorCard(BuildContext context, Sponsor sponsor) {
    final logoH = context.hp(12).clamp(80.0, 120.0);

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
          child: Padding(
            padding: EdgeInsets.all(context.cardPad),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: logoH,
                  width: double.infinity,
                  child: Image.network(
                    sponsor.logo,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(Icons.image_not_supported,
                          color: context.textSecondary),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sponsor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.sp(12),
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        sponsor.sponsorshipLevel,
                        style: TextStyle(
                          fontSize: context.sp(10),
                          color: AppColors.accentGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}