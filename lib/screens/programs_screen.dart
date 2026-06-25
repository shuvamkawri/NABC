import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../utils/responsive.dart';
import '../models/user_model.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final List<Program> _programs = [
    Program(id: '1', title: 'Business Leadership Forum', description: 'A high-level forum on entrepreneurship and business growth in the Bengali community.', date: 'July 3, 2026', time: '10:00 AM', venue: 'Conference Hall A', category: 'Business', status: 'On Time', imageUrl: ''),
    Program(id: '2', title: 'Health & Wellness Seminar', description: 'Expert panel on nutrition, mental health, and wellness practices.', date: 'July 4, 2026', time: '11:00 AM', venue: 'Conference Hall B', category: 'Health', status: 'On Time', imageUrl: ''),
    Program(id: '3', title: 'Literary Summit', description: 'Authors and publishers gather for discussions on Bengali literature.', date: 'July 3, 2026', time: '2:00 PM', venue: 'Meeting Room 1', category: 'Other', status: 'On Time', imageUrl: ''),
    Program(id: '4', title: 'Technology & Innovation Talk', description: 'Future of AI and tech for the diaspora community.', date: 'July 4, 2026', time: '3:00 PM', venue: 'Conference Hall A', category: 'Business', status: 'Delayed', imageUrl: ''),
    Program(id: '5', title: 'Cultural Heritage Workshop', description: 'Interactive workshop on Bengali art, dance, and music traditions.', date: 'July 5, 2026', time: '1:00 PM', venue: 'Community Hall', category: 'Other', status: 'On Time', imageUrl: ''),
  ];

  final List<Program> _filmFestival = [
    Program(id: 'f1', title: 'Belaseshe (2015)', description: 'Award-winning Bengali film about an aging couple seeking divorce after 55 years.', date: 'July 3, 2026', time: '2:00 PM', venue: 'Cinema Hall', category: 'Film', status: 'On Time', imageUrl: ''),
    Program(id: 'f2', title: 'Aparajito (2022)', description: 'A biographical film on director Satyajit Ray\'s early life.', date: 'July 4, 2026', time: '3:30 PM', venue: 'Cinema Hall', category: 'Film', status: 'On Time', imageUrl: ''),
    Program(id: 'f3', title: 'Shororipu (2024)', description: 'A gripping thriller that explores the dark side of social media.', date: 'July 5, 2026', time: '2:00 PM', venue: 'Cinema Hall', category: 'Film', status: 'On Time', imageUrl: ''),
    Program(id: 'f4', title: 'NABC Award Ceremony', description: 'Annual awards recognizing contributions to Bengali arts and culture.', date: 'July 5, 2026', time: '5:30 PM', venue: 'Main Stage', category: 'Film', status: 'On Time', imageUrl: ''),
  ];

  final List<Program> _specialScreenings = [
    Program(id: 's1', title: 'Special Screening: Pather Panchali', description: 'Restored 4K screening of Satyajit Ray\'s classic with live commentary.', date: 'July 3, 2026', time: '6:00 PM', venue: 'Cinema Hall', category: 'Screening', status: 'On Time', imageUrl: ''),
    Program(id: 's2', title: 'World Premiere: Ekti Nadir Naam', description: 'World premiere of a new Bengali diaspora film with the director Q&A.', date: 'July 4, 2026', time: '7:00 PM', venue: 'Cinema Hall', category: 'Screening', status: 'Delayed', imageUrl: ''),
    Program(id: 's3', title: 'Documentary: Crossing Borders', description: 'Documentary on Bengali immigrants and their journey to the USA.', date: 'July 5, 2026', time: '4:00 PM', venue: 'Cinema Hall', category: 'Screening', status: 'On Time', imageUrl: ''),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'On Time': return AppColors.successGreen;
      case 'Delayed': return AppColors.warningYellow;
      case 'Cancelled': return AppColors.errorRed;
      default: return AppColors.mediumGrey;
    }
  }

  Color _catColor(String c) {
    switch (c) {
      case 'Business': return AppColors.primaryBlue;
      case 'Health': return const Color(0xFF2E7D32);
      case 'Film': return const Color(0xFF6A1B9A);
      case 'Screening': return const Color(0xFFD32F2F);
      default: return AppColors.mediumGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs & Film Festival'),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Programs'),
            Tab(text: 'Film Festival'),
            Tab(text: 'Special Screening'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildList(context, _programs),
          _buildList(context, _filmFestival),
          _buildList(context, _specialScreenings),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Program> programs) {
    return ListView.builder(
      padding: EdgeInsets.all(context.pagePad),
      itemCount: programs.length,
      itemBuilder: (_, i) => _buildCard(context, programs[i]),
    );
  }

  Widget _buildCard(BuildContext context, Program p) {
    final catColor = _catColor(p.category);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(context.cardRadius),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: context.cardPad, vertical: 8),
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.cardRadius)),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    p.category,
                    style: TextStyle(
                      color: catColor,
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _statusColor(p.status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  p.status,
                  style: TextStyle(
                    color: _statusColor(p.status),
                    fontSize: context.sp(11),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.cardPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: context.sp(14),
                    color: context.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  p.description,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: context.sp(12),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _chip(context, Icons.calendar_today_outlined, p.date, catColor),
                    const SizedBox(width: 8),
                    _chip(context, Icons.access_time_outlined, p.time, catColor),
                  ],
                ),
                const SizedBox(height: 6),
                _chip(context, Icons.location_on_outlined, p.venue, catColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(
      BuildContext context, IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: context.sp(11),
            color: context.textSecondary,
          ),
        ),
      ],
    );
  }
}