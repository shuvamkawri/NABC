import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../widgets/custom_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: 'About NABC',
        subtitle:
        '46th North American Bengali Conference',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(context.cardPad),
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
                    '46th North American Bengali Conference 2026',
                    style: TextStyle(
                      fontSize: context.sp(17),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _infoRow(Icons.calendar_today, 'July 3–5, 2026', context),
                  const SizedBox(height: 8),
                  _infoRow(
                    Icons.location_on,
                    'Westchester County Center, White Plains, NY',
                    context,
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                      Icons.people, '100+ Performers | 5000+ Attendees', context),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle(context, 'About NABC'),
            const SizedBox(height: 12),
            Text(
              'The North American Bengali Conference (NABC) began in 1981 under the leadership of the Cultural Association of Bengal (CAB). Since its inception, NABC has grown into the largest and most celebrated international Bengali cultural event outside India and Bangladesh.',
              style: TextStyle(
                fontSize: context.sp(13),
                color: context.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Over the decades, NABC has been hosted annually in major cities across the USA and Canada — including New York, California, Toronto, Chicago, Houston, Florida, New Jersey, Atlanta, Boston, and Baltimore. Each conference showcases the vibrancy of Bengali culture through music concerts, dance performances, theatrical productions, literary forums, business summits, and film festivals.',
              style: TextStyle(
                fontSize: context.sp(13),
                color: context.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle(context, 'Our Mission'),
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(context.cardPad),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(context.cardRadius),
                border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
              ),
              child: Text(
                'To unite Bengalis living across North America and celebrate their shared cultural roots through music, dance, literature, and community bonding.',
                style: TextStyle(
                  fontSize: context.sp(13),
                  color: context.textPrimary,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle(context, 'Event Highlights'),
            const SizedBox(height: 12),
            _buildFeatureItem(context, 'Music & Dance',
                'Performances by renowned artists and musicians', Icons.music_note),
            _buildFeatureItem(context, 'Film Festival',
                'Showcase of Bengali and Indian cinema', Icons.movie),
            _buildFeatureItem(context, 'Literary Summit',
                'Authors and publishers gathering', Icons.library_books),
            _buildFeatureItem(context, 'Business Forum',
                'Professional networking and entrepreneurship', Icons.business),
            _buildFeatureItem(context, 'Fashion Shows',
                'Indian ethnic attire and jewelry exhibition', Icons.shopping_bag),
            _buildFeatureItem(context, 'Youth Forum',
                'Platform for young leaders and changemakers', Icons.groups),
            const SizedBox(height: 24),

            _sectionTitle(context, 'Hosting Organization'),
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(context.cardPad),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(context.cardRadius),
                boxShadow: context.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cultural Association of Bengal (CAB)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: context.sp(15),
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'CAB has been organizing NABC for nearly half a century with dedicated volunteers and community leaders who put their valuable time, effort, and resources to make NABC the biggest international Bengali conference.',
                    style: TextStyle(
                      fontSize: context.sp(13),
                      color: context.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '📍 Location: New York\n🌐 Website: www.cab.org',
                    style: TextStyle(
                      fontSize: context.sp(12),
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle(context, 'Get in Touch'),
            const SizedBox(height: 12),
            _buildContactItem(context, 'Email', 'contact@nabc2026.org', Icons.email),
            _buildContactItem(context, 'Phone', '+1 (555) 123-4567', Icons.phone),
            _buildContactItem(context, 'Website', 'www.nabcapp.com', Icons.language),
            const SizedBox(height: 24),

            _sectionTitle(context, 'Follow Us'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildSocialButton(context, 'Facebook', Icons.facebook),
                _buildSocialButton(context, 'Instagram', Icons.camera_alt),
                _buildSocialButton(context, 'YouTube', Icons.video_library),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: context.sp(13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: context.sp(17),
        fontWeight: FontWeight.bold,
        color: context.textPrimary,
      ),
    );
  }

  Widget _buildFeatureItem(
      BuildContext context, String title, String description, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: cs.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.sp(13),
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: context.sp(12),
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
      BuildContext context, String label, String value, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: cs.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: context.sp(11),
                    color: context.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.sp(13),
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(8),
        color: context.cardBg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: context.textPrimary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: context.sp(12),
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}